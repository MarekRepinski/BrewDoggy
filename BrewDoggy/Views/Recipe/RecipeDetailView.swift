//
//  RecipeDetailView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-08.
//

import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.timestamp, ascending: true)], animation: .default)
    private var recipies: FetchedResults<Recipe>
    @FetchRequest(entity: BrewType.entity(), sortDescriptors: [], animation: .default)
    private var brewTypes: FetchedResults<BrewType>
    @FetchRequest(entity: RecipeItem.entity(), sortDescriptors: [], animation: .default)
    private var recipeItems: FetchedResults<RecipeItem>
    var recipe: Recipe
    
    var recipeIndex: Int {
        recipies.firstIndex(where: { $0.id == recipe.id})!
    }
    
    var currentItems: [RecipeItem] {
        recipeItems.filter { rI in
            (rI.recipeItemToRecipe == recipe)
        }
    }
    
    var body: some View {
        ScrollView {
            RecipeImage(image: Image(recipe.picture!))
                .padding(.top, 20)

            HStack {
                VStack(alignment: .leading) {
                    Text("\((recipe.recipeToBrewType?.typeDescription)!) - \(recipe.name!)")
                        .font(.title)
                }
                Spacer()
                FavoriteButton(isSet:
                                Binding<Bool>(
                                    get: {self.recipies[recipeIndex].isFavorite},
                                    set: { p in self.recipies[recipeIndex].isFavorite = p})
                )
            }
            .padding(.horizontal, 15)

            Divider()

            Text("Recipe:")
                .font(.title2)
                .bold()

            VStack(alignment: .leading, spacing: 5) {
                ForEach(currentItems) {rI in
                    RecipeItemView(item: rI.itemDescription!, amount: rI.amount!, measure: rI.measurement!)
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 15)

            Divider()

            Text("Directions:")
                .font(.title2)
                .bold()

            VStack(alignment: .leading) {
                Text("\(self.recipies[recipeIndex].instructions!)")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 15)
        }
        .navigationTitle(recipe.name!)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggle(r: Recipe) {
        r.isFavorite.toggle()
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct RecipeItemView: View {
    var item: String
    var amount: String
    var measure: String
    
    var body: some View {
        HStack {
            Text(item)
            Spacer()
            Text("\(amount) \(measure)")
        }
        .padding(.horizontal, 50)
    }
}

//struct RecipeDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeListView()
//    }
//}
