//
//  WineCellarDetailView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-03-02.
//

import SwiftUI

struct WineCellarDetailView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Brew.timestamp, ascending: false)], animation: .default)
    private var brews: FetchedResults<Brew>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WineCellar.timestamp, ascending: false)], animation: .default)
    private var stores: FetchedResults<WineCellar>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Taste.date, ascending: true)], animation: .default)
    private var tastes: FetchedResults<Taste>

    @State private var types: [String] = []
    @State private var bruteForceReload = false
    @State private var editIsActive = false
    @State private var yearsInStore = ""
    @State private var showTaste = false
    @State private var taste: Taste? = nil
    @State private var deleteOffSet: IndexSet = [0]
    @State private var askBeforeDelete2 = false
    @State private var startGrade = -1
    @State private var brew: Brew? = nil
    @State private var homeBrewed = false
    @State private var goToBrew = false
    @State private var storeIsEmptyAlert = false
    @State private var addTasteIsActive = false
    @Binding var isAddActive: Bool

    var store: WineCellar
    var flushAfter = false

    var filteredTasteItems: [Taste] {
        tastes.filter { taste in
            (taste.tasteToWineCellar == store)
        }
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: EditWineCellarView(isSet: $bruteForceReload, store: store, minBottles: minBottles(store: store)),
                           isActive: $editIsActive) { EmptyView() }.hidden()

            VStack(alignment: .center) {
                RecipeImage(image: UIImage(data: store.picture!)!)
                    .padding(.top, 20)

                Text("\(store.name!)")
                    .font(.title)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Start: \(dateForm(d: store.start!))")
                    Spacer()
                    Text("\(yearsInStore)")
                }
                HStack {
                    if !homeBrewed {
                        Text("Brew: *not* homebrewed")
                    } else {
                        Button(action: { goToBrew = true }) {
                            Text("Brew: \(getBrew())")
                        }
                    }
                    Spacer()
                    Button("Create QR-code") {
                        print("Create QR-code")
                    }
                }
                HStack {
                    Text("\"\(store.comment!)\"")
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()
                    
                    Text("\(bottlesLeft(store: store))")
                        .font(.largeTitle)
                        .padding()
                    
                    Image(bottlesLeftIcon(store: store))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
            }
            .padding(.horizontal, 15)

            Divider()

            VStack{
                HStack{
                    Spacer()
                    Text("Taste")
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
            .padding(5)
            .onTapGesture {
                if bottlesLeft(store: store) < 1 { storeIsEmptyAlert = true }
                else { addTasteIsActive = true }
            }
            .alert(isPresented: $storeIsEmptyAlert) {
                Alert(title: Text("Your store is empty"),
                      message: Text("You cant taste something that isn't there.."),
                      dismissButton: .cancel())
            }
            NavigationLink(destination: AddTasteView(store: store, maxNoOfBottles: bottlesLeft(store: store)),
                           isActive: $addTasteIsActive) { EmptyView() }.hidden()

            VStack(alignment: .leading, spacing: 5) {
                List {
                    ForEach(filteredTasteItems) {fT in
                        HStack {
                            Text("\(dateForm(d: fT.date!))")
                            Spacer()
                            GradeStarsNB(grade: Int(fT.rate))
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            taste = fT
                            showTaste = true
                        }
                    }
                    .onDelete(perform: onDelete)
                }
            }
            .padding(.bottom, 50)
            .alert(isPresented: $askBeforeDelete2) {
                Alert(title: Text("Deleting a Taste"),
                      message: Text("This action can not be undone. Are you really sure?"),
                      primaryButton: .default(Text("Yes")) { deleteTaste()},
                      secondaryButton: .cancel(Text("No")))
            }

            NavigationLink(destination: BrewDetailView(isAddActive: $isAddActive, brew: brew ?? brews[0]),
                           isActive: $goToBrew) { EmptyView() }.hidden()
        }
        .onAppear() {
            yearsInStore = timeInStore(start: store.start!)
            homeBrewed = isHomeBrewed()
        }
        .sheet(isPresented: $showTaste) {
            DetailTasteView(taste: $taste)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
                                    if flushAfter {
                                        modelData.flush = true
                                        modelData.wineCellarGo = true
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                    if isAddActive {
                                        isAddActive = false
                                    } else {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
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
        .navigationTitle(store.name!)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func isHomeBrewed() -> Bool {
        if let b = store.wineCellarToBrew {
            brew = b
            return true
        }
        return false
    }
    
    private func getSubstring(s: String) -> String {
        var rc = s

        if s.count > 25 {
            let end = s.index(s.startIndex, offsetBy: 22)
            rc = String(s[s.startIndex..<end]) + "..."
        }
        return rc
    }
    
    private func onDelete(offsets: IndexSet) {
        deleteOffSet = offsets
        askBeforeDelete2 = true
    }
    
    private func deleteTaste() {
        withAnimation {
            deleteOffSet.map { filteredTasteItems[$0] }.forEach(viewContext.delete)
        }
        saveViewContext()
    }

    private func getBrew() -> String {
        if let b = store.wineCellarToBrew {
            return b.name!
        } else {
            return "Not homebrewed"
        }
    }
    
    private func timeInStore(start: Date) ->  String {
        let days = daysBetween(start: start, end: Date())
        if days < 365 { return String("\(days/30) months in store") }
        else { return String(format: "%.1f years in store", Double(days)/365.0) }
    }
    
    private func daysBetween(start: Date, end: Date) -> Int {
       Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    private func dateForm(d: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: d)
    }

    private func minBottles(store: WineCellar) -> Int {
        var rc = 0
        for taste in tastes {
            if taste.tasteToWineCellar == store {
                rc += Int(taste.bottles)
            }
        }

        return rc
    }
    
    private func bottlesLeft(store: WineCellar) -> Int {
        var rc = store.bottlesStart
        for taste in tastes {
            if taste.tasteToWineCellar == store {
                rc -= taste.bottles
            }
        }

        return Int(rc)
    }
    
    private func bottlesLeftIcon(store: WineCellar) -> String {
        let bottles = bottlesLeft(store: store)
        switch bottles {
        case 0:
            return "winBottle0"
            
        case 1:
            return "winBottle1"
            
        case 2:
            return "winBottle2"
            
        case 3:
            return "winBottle3"
            
        case 4:
            return "winBottle4"
            
        default:
            return "winBottle5"
        }
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

struct DetailTasteView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var startGrade = -1
    @Binding var taste: Taste?
    
    var body: some View {
        ScrollView {
            Text("Taste of \((taste?.tasteToWineCellar!.name) ?? "")")
                .font(.title)
                .bold()
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    Text("\(dateForm(d: taste?.date))")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding()

                HStack {
                    Spacer()
                    Text("\(taste!.bottles) bottles tasted")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding()

                HStack {
                    Spacer()
                    GradeStarsNB(grade: Int(taste!.rate))
                    Spacer()
                }
                .padding()

                Divider()

                Text("Comment:")
                    .font(.title3)
                    .bold()

                Text("\(taste?.comment ?? "")")
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
            if (taste == nil) {
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
}

//struct WineCellarDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        WineCellarDetailView()
//    }
//}
