//
//  EditRecipeView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-11.
//

import SwiftUI

struct EditRecipeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel = ViewModel()

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.timestamp, ascending: true)], animation: .default)
    private var recipies: FetchedResults<Recipe>

    @FetchRequest(entity: BrewType.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BrewType.timestamp, ascending: true)], animation: .default)
    private var brewTypes: FetchedResults<BrewType>

    @FetchRequest(entity: RecipeItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \RecipeItem.sortId, ascending: true)], animation: .default)
    private var recipeItems: FetchedResults<RecipeItem>
    
    @FetchRequest(entity: UnitType.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \UnitType.unitTypeSort, ascending: true)],
                  predicate: NSPredicate(format: "unitTypeSort > 0"), animation: .default)
    private var unitTypes: FetchedResults<UnitType>

    @State private var title = "Add a new Recipe"
    @State private var name = ""
    @State private var instructions = ""
    @State private var recipeIndex = 0
    @State private var currentItems: [RecipeItem] = []
    @State private var selectedUnitType = ""
    @State private var uTypes: [String] = []
    @State private var selectedBrewType = ""
    @State private var bTypes: [String] = []
    @State private var showIngredientSheet = false

    var recipe: Recipe?
    
    var body: some View {

        VStack(alignment: .leading, spacing: 0.0) {
            Form {
                VStack(alignment: .center, spacing: 0.0) {
                    Button(action: { viewModel.choosePhoto() }, label: {
                        VStack(alignment: .center) {
                            Image(uiImage: viewModel.selectedImage ?? UIImage(named: "dricku2")!)
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 200)
                                .cornerRadius(15)

                            Text("Tap to change")
                                    .foregroundColor(.blue)
                                    .font(.footnote)
                        }
                    })
                }.padding(.init(top: 20, leading: 0, bottom: 0, trailing: 0))

                Section(header: Text("Name:")) {
                    TextField("Name of recipe", text: $name)
                }
                Section(header: Text("Type:")) {
                    Picker("Recipe Type", selection: $selectedBrewType) {
                        ForEach(bTypes, id: \.self) {
                            Text($0)
                        }
                    }

                    Picker("Measurement System", selection: $selectedUnitType) {
                        ForEach(uTypes, id: \.self) {
                            Text($0)
                        }
                    }
                }
                List {
                    Section(header: Text("Ingredients:")) {
                    ForEach(currentItems) {rI in
                        HStack {
                            Text("\(rI.itemDescription!)")
                            Spacer()
                            Text("\(rI.amount!)")
                            Text("\(rI.recipeItemToUnit!.unitAbbreviation!)")
                        }
                    }
                        NavigationLink(destination: IngredientsView(currentItems: $currentItems, unitType: selectedUnitType)) {
                            HStack {
                                Spacer()
                                Text("Edit Ingredients")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                Section(header: Text("Instructions:")) {
                    TextEditor(text: $instructions)
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
            .navigationBarItems(trailing: Image(systemName: "camera").foregroundColor(.blue).onTapGesture { viewModel.takePhoto() }.padding())
            .fullScreenCover(isPresented: $viewModel.isPresentingImagePicker) {
                ImagePicker(sourceType: viewModel.sourceType, completionHandler: viewModel.didSelectImage)
            }
        }
    }
    
    private func setUpStates() {
        bTypes.removeAll()
        for bt in brewTypes {
            bTypes.append(bt.typeDescription!)
        }
        uTypes.removeAll()
        for ut in unitTypes {
            uTypes.append(ut.unitTypeName!)
        }
        if let r = recipe {
            name = r.name!
            title = "Edit recipe"
            viewModel.selectedImage = UIImage(data: r.picture!)!
            instructions = r.instructions!
            if selectedBrewType == "" { selectedBrewType = r.recipeToBrewType!.typeDescription! }
            if selectedUnitType == "" { selectedUnitType = r.recipeToUnitType!.unitTypeName! }
            recipeIndex = recipies.firstIndex(where: { $0.id == r.id})!

            currentItems = recipeItems.filter { rI in
                    (rI.recipeItemToRecipe == r)
            }
        }
    }
}

//struct EditRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRecipeView()
//    }
//}
