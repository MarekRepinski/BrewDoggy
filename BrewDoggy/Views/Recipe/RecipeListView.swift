//
//  RecipeListView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-08.
//

import SwiftUI

struct RecipeListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.timestamp, ascending: false)], animation: .default)
    private var recipies: FetchedResults<Recipe>
    @FetchRequest(entity: BrewType.entity(), sortDescriptors: [], animation: .default)
    private var brewTypes: FetchedResults<BrewType>
    
    @State private var showFavoritesOnly = false
    @State private var bruteForceReload = false
    @State private var showList = true
    
    var filteredRecipies: [Recipe] {
        recipies.filter { r in
            (!showFavoritesOnly || r.isFavorite)
        }
    }
    
    var body: some View {
        List {
            if showList { //Show recipies as a list
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                ForEach(filteredRecipies) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe, returnShow: showList)) {
                        HStack {
                            Image(uiImage: UIImage(data: recipe.picture!)!)
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            Text("\(recipe.recipeToBrewType!.typeDescription!) - \(recipe.name!)")
                            
                            Spacer()
                            
                            if recipe.isFavorite {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                }
                .onDelete(perform: onDelete)
            } else { // Show recipies sorted by brewtype
                Image("RecipePic")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipped()

                ForEach(brewTypes) { bt in
                    CategoryRow(bt: bt, recipeList: filteredRecipies, returnShow: showList)
                    .listRowInsets(EdgeInsets())
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Your Recipies:")
        .navigationBarItems(trailing:
                                NavigationLink(destination: EditRecipeView(isSet: $bruteForceReload, recipe: nil, returnShow: showList)
                                                .environment(\.managedObjectContext, viewContext)) {
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
    }
    
    private func onDelete(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredRecipies[$0] }.forEach(viewContext.delete)
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

}

struct CategoryRow: View {
    var bt: BrewType
    var recipeList: [Recipe]
    var returnShow: Bool
    var items: [Recipe] {
        recipeList.filter { r in
            (r.recipeToBrewType == bt)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(bt.typeDescription ?? "Unknown")
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items){ recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe, returnShow: returnShow)) {
                            CategoryItem(recipe: recipe)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

struct CategoryItem: View {
    var recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading){
            Image(uiImage: UIImage(data: recipe.picture!)!)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text(recipe.name!)
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
