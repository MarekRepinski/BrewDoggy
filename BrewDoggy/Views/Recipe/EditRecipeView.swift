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
    @State private var selectedUnitType = "Metric"
    @State private var showUnitTypePicker = false
    @State private var uTypes: [String] = []
    @State private var showBrewTypePicker = false
    @State private var selectedBrewType = "Wine"
    @State private var bTypes: [String] = []
    @State var ingredientItems = [ItemRow(name: "dummy", amount: "dummy", unit: "dummy")]
    
    var recipe: Recipe?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 5.0) {
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
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
            }
            .padding(.init(top: 20, leading: 0, bottom: 5, trailing: 0))
            .onAppear(){
                setUpStates()
            }
            .navigationBarTitle("\(title)",displayMode: .inline)
            .navigationBarItems(trailing: Image(systemName: "camera").foregroundColor(.blue).onTapGesture { viewModel.takePhoto() }.padding())
            .fullScreenCover(isPresented: $viewModel.isPresentingImagePicker) {
                ImagePicker(sourceType: viewModel.sourceType, completionHandler: viewModel.didSelectImage)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Name:")
                        .bold()
                    TextField("Name of recipe", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal, 15)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)

                HStack {
                    HStack {
                        Text("Type:")
                            .bold()
                        Button(selectedBrewType){
                            self.showBrewTypePicker.toggle()
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                    
                    Spacer()
                    HStack {
                        Text("System:")
                            .bold()
                        Button(selectedUnitType){
                            self.showUnitTypePicker.toggle()
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                }
                .padding(.vertical, 5)

                if showBrewTypePicker {
                    Picker("Recipe Type", selection: $selectedBrewType) {
                        ForEach(bTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                    .onTapGesture {
                        self.showBrewTypePicker.toggle()
                    }
                }
                
                if showUnitTypePicker {
                    Picker("Measurement System", selection: $selectedUnitType) {
                        ForEach(uTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                    .onTapGesture {
                        self.showUnitTypePicker.toggle()
                    }
                }

                VStack {
                    Text("Ingredients:")
                        .bold()
                    ForEach(ingredientItems) {rI in
                        HStack {
                            Text("\(rI.name)")
                            Spacer()
                            Text("\(rI.amount)")
                            Text("\(rI.unit)")
                        }
                    }
                    NavigationLink(destination: IngredientsView(ingredientItems: $ingredientItems, unitType: selectedUnitType)) {
                        HStack(alignment: .center) {
                            Text("Edit Ingredients")
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)

                VStack {
                    Text("Instructions:")
                        .bold()
                    TextEditor(text: $instructions)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)

//                    Button("Save") {
//                        let newRecipe = Recipe(context: viewContext)
//                        newRecipe.name = self.name
//                        newRecipe.picture = self.picture
//                        newRecipe.instructions = self.instructions
//                        newRecipe.timestamp = Date()
//
//                        try? self.viewContext.save()

//                        self.presentationMode.wrappedValue.dismiss()
//                    }
                
            }.padding(.horizontal, 15)
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
            
            if ingredientItems.count == 1 {
                if ingredientItems[0].unit == "dummy" {
                    ingredientItems.removeAll()
                    for rI in currentItems {
                        ingredientItems.append(ItemRow(name: rI.itemDescription!, amount: rI.amount!, unit: rI.recipeItemToUnit!.unitAbbreviation!))
                    }
                }
            }
        }
    }
}

//struct EditRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRecipeView()
//    }
//}
