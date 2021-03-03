//
//  BrewListView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-24.
//

import SwiftUI

struct BrewListView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Brew.timestamp, ascending: false)], animation: .default)
    private var brews: FetchedResults<Brew>
    @FetchRequest(entity: BrewType.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BrewType.timestamp, ascending: false)], animation: .default)
    private var brewTypes: FetchedResults<BrewType>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BrewCheck.date, ascending: true)], animation: .default)
    private var brewChecks: FetchedResults<BrewCheck>
    
    @State private var showOnGoingOnly = false          // Show only brews that are brewing
    @State private var bruteForceReload = false         // Bool used in binding to force reload
    @State private var showList = true                  // Show brews as list or categories
    @State private var gradeColor = Color.green         // Change color of image depending on grade
    @State private var askBeforeDelete = false          // Activate ask before delete Alert
    @State private var cantBeDeleted = false            // Activete cant be deleted Alert (Brew has checks)
    @State private var editIsActive = false             // Activate AddBrew NavLink
    @State private var deleteOffSet: IndexSet = [0]     // Container for brews to be deleted
    
    var filteredBrews: [Brew] {
        brews.filter { r in
            (!showOnGoingOnly || !r.isDone)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                if showList { //Show brews as a list
                    Toggle(isOn: $showOnGoingOnly) {
                        Text("Brewing only")
                    }
                    ForEach(filteredBrews) { brew in
                        NavigationLink(destination: BrewDetailView(brew: brew)) {
                            HStack {
                                Image(uiImage: UIImage(data: brew.picture!)!)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                
                                Text("\(brew.brewToBrewType!.typeDescription!) - \(brew.name!)")
                                
                                Spacer()
                                
                                if brew.isDone {
                                    Image(systemName: "\(brew.grade).circle.fill")
                                        .imageScale(.large)
                                        .foregroundColor(brew.grade < 3 ? Color.red : Color.green)
                                }
                            }
                            .contentShape(Rectangle())
                        }
                    }
                    .onDelete(perform: onDelete)
                } else { // Show recipies sorted by brewtype
                    Image("brewHeader")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipped()
                    
                    ForEach(brewTypes) { bt in
                        BrewCategoryRow(bt: bt, brewList: filteredBrews)
                            .listRowInsets(EdgeInsets())
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Your Brews:")
            .navigationBarItems(leading:
                                    Button(action: {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }) {
                                        HStack{
                                            Image(systemName: "chevron.left")
                                            Text("Back")
                                        }
                                    }, trailing:
                                        Button(action: { editIsActive = true}) {
                                            Image(systemName: "plus")
                                                .imageScale(.large)
                                                .padding()
                                        }
            )
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    
                    VStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(Color(.blue))
                            .imageScale(.large)
                        Text("Home")
                            .foregroundColor(Color(.blue))
                            .font(.footnote)
                            .bold()
                    }
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "list.dash")
                            .foregroundColor(Color(.blue))
                            .imageScale(.large)
                        Text("List")
                            .foregroundColor(Color(.blue))
                            .font(.footnote)
                            .bold()
                    }
                    .onTapGesture {
                        showList = true
                    }
                    .alert(isPresented: $cantBeDeleted) {
                        Alert(title: Text("Cant delete Brew"),
                              message: Text("This Brew cant be deleted because it has Checks. Remove the Checks first!"),
                              dismissButton: .cancel())
                    }

                    Spacer()
                    
                    VStack {
                        Image(systemName: "square.grid.4x3.fill")
                            .foregroundColor(Color(.blue))
                            .imageScale(.large)
                        Text("Sorted")
                            .foregroundColor(Color(.blue))
                            .font(.footnote)
                            .bold()
                    }
                    .onTapGesture {
                        showList = false
                    }
                    .alert(isPresented: $askBeforeDelete) {
                        Alert(title: Text("Deleting a Brew"),
                              message: Text("This action can not be undone. Are you really sure?"),
                              primaryButton: .default(Text("Yes")) { deleteBrew() },
                              secondaryButton: .cancel(Text("No")))
                    }
                    
                    Spacer()
                    NavigationLink(destination: AddBrewView(isSet: $bruteForceReload),
                                   isActive: $editIsActive) { EmptyView() }.hidden()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear() {
            if modelData.flush {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func onDelete(offsets: IndexSet) {
        deleteOffSet = offsets
        if deletableBrew() { askBeforeDelete = true }
        else { cantBeDeleted = true }
    }
    
    private func deletableBrew() -> Bool {
        for index in deleteOffSet {
            for bc in brewChecks {
                if bc.brewCheckToBrew == filteredBrews[index] { return false }
            }
        }
        return true
    }
    
    private func deleteBrew() {
        withAnimation {
            deleteOffSet.map { filteredBrews[$0] }.forEach(viewContext.delete)
        }
        askBeforeDelete = false
        saveViewContext()
    }
    
    private func saveViewContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    struct BrewCategoryRow: View {
        @State private var isAddActive = false

        var bt: BrewType
        var brewList: [Brew]
        var items: [Brew] {
            brewList.filter { r in
                (r.brewToBrewType == bt)
            }
        }
        
        var body: some View {
            if items.count > 0 {
                VStack(alignment: .leading) {
                    Text(bt.typeDescription ?? "Unknown")
                        .font(.headline)
                        .padding(.leading, 15)
                        .padding(.top, 5)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(items){ brew in
                                NavigationLink(destination: BrewDetailView(brew: brew)) {
                                    BrewCategoryItem(brew: brew)
                                }
                            }
                        }
                    }
                    .frame(height: 185)
                }
            }
        }
    }
    
    struct BrewCategoryItem: View {
        var brew: Brew
        
        var body: some View {
            VStack(alignment: .leading){
                Image(uiImage: UIImage(data: brew.picture!)!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 155, height: 155)
                    .cornerRadius(5)
                Text(brew.name!)
                    .foregroundColor(.primary)
                    .font(.caption)
            }
            .padding(.leading, 15)
        }
    }
}

struct BrewListView_Previews: PreviewProvider {
    static var previews: some View {
        BrewListView()
    }
}
