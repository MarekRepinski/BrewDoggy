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
    @FetchRequest(entity: BrewType.entity(), sortDescriptors: [], animation: .default)
    private var brewTypes: FetchedResults<BrewType>
    
    @State private var showOnGoingOnly = false
    @State private var bruteForceReload = false
    @State private var showList = true
    @State private var gradeColor = Color.green
    
    var filteredBrews: [Brew] {
        brews.filter { r in
            (!showOnGoingOnly || !r.isDone)
        }
    }
    
    var body: some View {
        List {
            if showList { //Show recipies as a list
                Toggle(isOn: $showOnGoingOnly) {
                    Text("On Going only")
                }
                ForEach(filteredBrews) { brew in
                    NavigationLink(destination: EmptyView()) {
                        HStack {
                            Image(uiImage: UIImage(data: brew.picture!)!)
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            Text("\(brew.brewToBrewType!.typeDescription!) - \(brew.name!)")
                            
                            Spacer()
                            
                            if brew.isDone {
//                                Text("\(brew.grade) of 5")
                                Image(systemName: "\(brew.grade).circle.fill")
//                                Image(systemName: "checkmark.seal.fill")
                                    .imageScale(.large)
                                    .foregroundColor(gradeColor)
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
//                    CategoryRow(bt: bt, recipeList: filteredRecipies, returnShow: showList)
//                    .listRowInsets(EdgeInsets())
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Your Brews:")
        .navigationBarItems(trailing:
                                NavigationLink(destination: EmptyView()) {
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
    }}

struct BrewListView_Previews: PreviewProvider {
    static var previews: some View {
        BrewListView()
    }
}
