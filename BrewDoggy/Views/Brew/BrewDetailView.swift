//
//  BrewDetailView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-26.
//

import SwiftUI

struct BrewDetailView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Brew.timestamp, ascending: false)], animation: .default)
    private var brews: FetchedResults<Brew>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BrewCheck.date, ascending: true)], animation: .default)
    private var brewChecks: FetchedResults<BrewCheck>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.timestamp, ascending: false)], animation: .default)
    private var recipies: FetchedResults<Recipe>

    @State private var bruteForceReload = false             // Bool used in binding to force reload
    @State private var editIsActive = false                 // Activate EditBrewView NavLink
    @State private var isDone = false                       // Check if brew is no longer brewing
    @State private var daysLeft = 0                         // Check how many days to ETA
    @State private var showCheck = false                    // Avtivate clicked check in sheet
    @State private var bc: BrewCheck? = nil                 // Container which brew check to show
    @State private var deleteOffSet: IndexSet = [0]         // Container for checks marked for delete
    @State private var askBeforeDelete2 = false             // Activate Delete Alert
    @State private var showGrade = 0                        // Input for show grading with GradeStar
    @State private var goToRecipe = false                   // Activate RecipeDetail NavLink
    @State private var recipe: Recipe? = nil                // Recipe object brew is linked to

    var brew: Brew                                          // Brew Object to display
    var flushAfter = false                                  // Flush Navigation history

    var filteredBrewItems: [BrewCheck] {
        brewChecks.filter { bc in
            (bc.brewCheckToBrew == brew)
        }
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: EditBrewView(isSet: $bruteForceReload, brew: brew),
                           isActive: $editIsActive) { EmptyView() }.hidden()

            NavigationLink(destination: RecipeDetailView(recipe: recipe ?? recipies[0]),
                           isActive: $goToRecipe) { EmptyView() }.hidden()

            RecipeImage(image: UIImage(data: brew.picture!)!)
                .padding(.top, 20)

            VStack(alignment: .center) {
                Text("\(brew.name!)")
                    .font(.title)
                if isDone {
                    GradeStars(grade: $showGrade)
                } else {
                    if daysLeft < 0 {
                        Text("Past Due date!!")
                            .foregroundColor(.red)
                    } else {
                        Text("\(daysLeft + 1) day\(daysLeft > 1 ? "s" : "") left")
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            VStack(alignment: .leading, spacing: 10) {
                Text("Recipe: \(brew.brewToRecipe!.name!) (\(brew.brewToBrewType!.typeDescription!))")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        goToRecipe = true
                    }
                HStack {
                    Text("Start: \(dateForm(d: brew.start!))")
                    Spacer()
                    if isDone {
                        Text("\(abvCalc(og: Double(brew.originalGravity)/1000, fg: Double(brew.finalGravity)/1000)) %")
                    } else {
                        Text("OG: \(brew.originalGravity)")
                    }
                }
                HStack {
                    Text("\(isDone ? "End" : "ETA"): \(dateForm(d: brew.eta!))")
                    Spacer()
                    NavigationLink(destination: CreateQR(id: brew.id!)) {
                        Text("Create QR-code")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal, 15)

            Divider()

            VStack{
                NavigationLink(destination: AddBrewCheckView(brew: brew)) {
                    HStack{
                        Spacer()
                        Text("Checks")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color.gray.opacity(0.5))
                }
            }
            .padding(5)

            VStack(alignment: .leading, spacing: 5) {
                List {
                    ForEach(filteredBrewItems) {fB in
                        HStack {
                            Text("\(dateForm(d: fB.date!))")
                            Text("\(getSubstring(s: fB.comment!))")
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            bc = fB
                            showCheck = true
                        }
                    }
                    .onDelete(perform: onDelete)
                }
            }
            .padding(.bottom, 50)
        }
        .onAppear() {
            if modelData.flush {
                self.presentationMode.wrappedValue.dismiss()
            }
            isDone = brew.isDone
            showGrade = Int(brew.grade)
            daysLeft = daysBetween(start: Date(), end: brew.eta!)
        }
        .alert(isPresented: $askBeforeDelete2) {
            Alert(title: Text("Deleting a Brew Check"),
                  message: Text("This action can not be undone. Are you really sure?"),
                  primaryButton: .default(Text("Yes")) { deleteBrewCheck() },
                  secondaryButton: .cancel(Text("No")))
        }
        .sheet(isPresented: $showCheck) {
            DetailCheckView(bc: $bc, og: Int(brew.originalGravity))
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
                                    if flushAfter {
                                        modelData.flush = true
                                        modelData.brewGo = true
                                    }
                                    self.presentationMode.wrappedValue.dismiss()
                                }) {
                                    HStack{
                                        Image(systemName: "chevron.left")
                                        Text("Back")
                                    }
                                }, trailing:
                                    Button(action: { editIsActive = true }) {
                                        Image(systemName: "pencil").padding()
                                            .imageScale(.large)
                                            .animation(.easeInOut)
                                            .padding()
                                    })
        .navigationTitle(brew.name!)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func getSubstring(s: String) -> String {
        var rc = s

        if s.count > 25 {
            let end = s.index(s.startIndex, offsetBy: 22)
            rc = String(s[s.startIndex..<end]) + "..."
        }
        return rc
    }
    
    private func abvCalc(og: Double, fg: Double) -> String {
        let abv = (76.08*(og-fg)/(1.775-og))*(fg/0.794)
        return String(format: "ABV: %.2f", abv)
    }

    private func onDelete(offsets: IndexSet) {
        deleteOffSet = offsets
        askBeforeDelete2 = true
    }
    
    private func deleteBrewCheck() {
        withAnimation {
            deleteOffSet.map { filteredBrewItems[$0] }.forEach(viewContext.delete)
        }
        saveViewContext()
    }

    private func daysBetween(start: Date, end: Date) -> Int {
       Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    private func dateForm(d: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: d)
    }

    private func saveViewContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct DetailCheckView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var bc: BrewCheck?
    var og: Int
    
    var body: some View {
        ScrollView {
            Text("Check on \((bc?.brewCheckToBrew?.name) ?? "")")
                .font(.title)
                .bold()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    Text("\(dateForm(d: bc?.date))")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding()
                
                HStack {
                    Text("Gravity: \(gravityStr(g: bc?.gravity))")
                        .font(.title3)
                        .bold()

                    if bc!.gravity > 0 && og > 0 {
                        Spacer()
                        Text("\(abvCalc(og: Double(og)/1000, fg: Double(bc!.gravity)/1000)) %")
                            .font(.title3)
                            .bold()
                    }
                    Spacer()
                }
                .padding()
                
                Divider()
                
                Text("Comment:")
                    .font(.title3)
                    .bold()

                Text("\(bc?.comment ?? "")")
                    .font(.title3)
                    .fixedSize(horizontal: false, vertical: true)

                Divider()
                
                HStack{
                    Spacer()

                    Button("Close") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .font(.title3)

                    Spacer()
                }

                Divider()
            }
            .padding(.horizontal, 15)
        }
        .onAppear() {
            if (bc == nil) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }.padding()
    }

    private func dateForm(d: Date?) -> String {
        var rc = ""

        if let dd = d {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            rc = formatter.string(from: dd)
        }
        
        return rc
    }

    private func gravityStr(g: Int64?) -> String {
        var rc = "No gravity measured."

        if let gg = g {
            if gg > 0 { rc = "\(gg)" }
        }
        
        return rc
    }
    
    private func abvCalc(og: Double, fg: Double) -> String {
        let abv = (76.08*(og-fg)/(1.775-og))*(fg/0.794)
        return String(format: "ABV: %.2f", abv)
    }
}

//struct BrewDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BrewDetailView()
//    }
//}
