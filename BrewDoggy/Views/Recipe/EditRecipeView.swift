//
//  EditRecipeView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-11.
//

import SwiftUI

struct EditRecipeView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.timestamp, ascending: true)], animation: .default)
    private var recipies: FetchedResults<Recipe>

    @FetchRequest(entity: BrewType.entity(), sortDescriptors: [], animation: .default)
    private var brewTypes: FetchedResults<BrewType>

    @FetchRequest(entity: RecipeItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \RecipeItem.sortId, ascending: true)], animation: .default)
    private var recipeItems: FetchedResults<RecipeItem>

    @State private var title = "Add a new Recipe"
    @State private var name = ""
    @State private var picture = ""
    @State private var instructions = ""
    @State private var recipeIndex = 0
    @State private var currentItems: [RecipeItem] = []
    @State private var selectedType = "Beer"
    @State private var types: [String] = []
    var recipe: Recipe?

    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Name of recipe", text: $name)
                    TextField("Picture", text: $picture)
                }
                Section {
                    Picker("Recipe Type", selection: $selectedType) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section {
                    TextField("Instructions", text: $instructions)
                }
                Section {
                    Button("Save") {
//                        let newRecipe = Recipe(context: viewContext)
//                        newRecipe.name = self.name
//                        newRecipe.picture = self.picture
//                        newRecipe.instructions = self.instructions
//                        newRecipe.timestamp = Date()
//
//                        try? self.viewContext.save()

//                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear(){
                setUpStates()
            }
            .navigationBarTitle("\(title)",displayMode: .inline)
            NavigationView {
                List {
                    ForEach(currentItems) {rI in
                        HStack {
                            Text("\(rI.itemDescription!)")
                            Spacer()
                            Text("\(rI.amount!)")
                            Text("\(rI.recipeItemToUnit!.unitAbbreviation!)")
                        }
                    }
                    .onMove(perform: whenMove)
                        .onDelete(perform: deleteRow)
                }
//                .toolbar {
//                    EditButton()
//                }
            }
        }
    }
    
    private func setUpStates() {
        for bt in brewTypes {
            types.append(bt.typeDescription!)
        }
        if let r = recipe {
            name = r.name!
            title = "Edit recipe"
            picture = r.picture!
            instructions = r.instructions!
            selectedType = r.recipeToBrewType!.typeDescription!
            recipeIndex = recipies.firstIndex(where: { $0.id == r.id})!

            currentItems = recipeItems.filter { rI in
                    (rI.recipeItemToRecipe == r)
            }
        }
    }

    private func deleteRow(offsets: IndexSet) {
        print("Recipe deleted")
    }

    private func whenMove(offsets: IndexSet, to destionation: Int) {
        currentItems.move(fromOffsets: offsets, toOffset: destionation)
        print("Moving")
    }
}

//struct EditRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRecipeView()
//    }
//}
