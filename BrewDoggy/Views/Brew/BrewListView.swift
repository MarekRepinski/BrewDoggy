//
//  BrewListView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-24.
//

import SwiftUI

struct BrewListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Brew.timestamp, ascending: false)], animation: .default)
    private var brews: FetchedResults<Brew>
    @FetchRequest(entity: BrewType.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BrewType.timestamp, ascending: false)], animation: .default)
    private var brewTypes: FetchedResults<BrewType>
    
    @State private var showOnGoingOnly = false
    @State private var bruteForceReload = false
    @State private var showList = true
    @State private var gradeColor = Color.green
    @State private var askBeforeDelete = false
    @State private var editIsActive = false
    @State private var isAddActive = false
    @State private var deleteOffSet: IndexSet = [0]
    
    var filteredBrews: [Brew] {
        brews.filter { r in
            (!showOnGoingOnly || !r.isDone)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
            NavigationLink(destination: AddBrewView(isSet: $bruteForceReload, isAddActive: $editIsActive),
                           isActive: $editIsActive) { EmptyView() }.hidden()
                if showList { //Show brews as a list
                    Toggle(isOn: $showOnGoingOnly) {
                        Text("Brewing only")
                    }
                    ForEach(filteredBrews) { brew in
                        NavigationLink(destination: BrewDetailView(isAddActive: $isAddActive, brew: brew)) {
                            HStack {
                                Image(uiImage: UIImage(data: brew.picture!)!)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                                Text("\(brew.brewToBrewType!.typeDescription!) - \(brew.name!)")
                                
                                Spacer()
                                
                                if brew.isDone {
                                    Image(systemName: "\(brew.grade).circle.fill")
                                        .imageScale(.large)
                                        .foregroundColor(brew.grade < 3 ? Color.red : Color.green)
                                }
                            }
                        }
                    }
                    //                .onDelete(perform: onDelete)
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
                    
                    
                    Spacer()
                }
            }
            .alert(isPresented: $askBeforeDelete) {
                Alert(title: Text("Deleting a recipe"),
                      message: Text("This action can not be undone. Are you really sure?"),
                      primaryButton: .default(Text("Yes")) { deleteBrew() },
                      secondaryButton: .cancel(Text("No")))
            }
        }
        .navigationBarHidden(true)
    }
    
    private func onDelete(offsets: IndexSet) {
        deleteOffSet = offsets
        askBeforeDelete = true
    }
    
    private func deleteBrew() {
        withAnimation {
            deleteOffSet.map { filteredBrews[$0] }.forEach(viewContext.delete)
        }
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
                                NavigationLink(destination: BrewDetailView(isAddActive: $isAddActive, brew: brew)) {
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
