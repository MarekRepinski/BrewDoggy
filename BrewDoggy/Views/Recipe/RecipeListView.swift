//
//  RecipeListView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-08.
//

import SwiftUI

struct RecipeListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.timestamp, ascending: false)], animation: .default)
    private var recipies: FetchedResults<Recipe>
    @FetchRequest(entity: BrewType.entity(), sortDescriptors: [], animation: .default)
    private var brewTypes: FetchedResults<BrewType>

    @State private var showFavoritesOnly = false
    @State private var bruteForceReload = false

    var filteredRecipies: [Recipe] {
        recipies.filter { r in
            (!showFavoritesOnly || r.isFavorite)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                ForEach(filteredRecipies) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
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
                .onDelete(perform: deleteRecipe)
            }
            .onAppear() {
                if brewTypes.count == 0 {
                    MockData(context: viewContext)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Your Recipies:")
            .navigationBarItems(trailing:
                                    NavigationLink(destination: EditRecipeView(isSet: $bruteForceReload, recipe: nil)
                                                    .environment(\.managedObjectContext, viewContext)) {
                                                        Image(systemName: "plus")
                                                    }
            )
//            .sheet(isPresented: $showingAddScreen) {
//                AddRecipeView().environment(\.managedObjectContext, viewContext)
//            }
        }
    }
    
    private func deleteRecipe(offsets: IndexSet) {
        print("Recipe deleted")
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
