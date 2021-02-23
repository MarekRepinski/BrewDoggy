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
    @FetchRequest(entity: RecipeItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \RecipeItem.sortId, ascending: true)], animation: .default)
    private var recipeItems: FetchedResults<RecipeItem>
    @FetchRequest(entity: UnitType.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \UnitType.unitTypeSort, ascending: true)],
                  predicate: NSPredicate(format: "unitTypeSort > 0"), animation: .default)
    private var unitTypes: FetchedResults<UnitType>

    @State private var currentItems: [ItemRow] = []
    @State private var metItems = [ItemRow]()
    @State private var impItems = [ItemRow]()
    @State private var usItems = [ItemRow]()
    @State private var pickerVisible = false
    @State private var selectedType = "Metric"
    @State private var types: [String] = []
    @State private var bruteForceReload = false
    @State private var goBack = false
    var recipe: Recipe
    
    var recipeIndex: Int {
        recipies.firstIndex(where: { $0.id == recipe.id})!
    }
    
    var filteredRecipeItems: [RecipeItem] {
        recipeItems.filter { r in
            (r.recipeItemToRecipe == recipe)
        }
    }
    

    var body: some View {
        ScrollView {
            // Fix: Back button
            NavigationLink(destination: RecipeListView(), isActive: $goBack) { EmptyView() }

            RecipeImage(image: UIImage(data: recipe.picture!)!)
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

            HStack {
                Spacer()

                Text("Recipe:")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button(selectedType){
                    self.pickerVisible.toggle()
                }
            }.padding(.horizontal, 15)

            if pickerVisible {
                Picker("", selection: $selectedType) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(InlinePickerStyle())
                .onTapGesture {
                    self.pickerVisible.toggle()
                    changeMeasurement(type: selectedType)
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                ForEach(currentItems) {rI in
                    RecipeItemView(item: rI.name, amount: rI.amount, measure: rI.unit)
                }
            }.onAppear() {
                types.removeAll()
                for ut in unitTypes {
                    types.append(ut.unitTypeName!)
                }
                setUpIngrediens()
                changeMeasurement(type: recipe.recipeToUnitType!.unitTypeName!)
                selectedType = recipe.recipeToUnitType!.unitTypeName!
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
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: { goBack = true }) {
            HStack{
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }, trailing:
            NavigationLink(destination: EditRecipeView(isSet: $bruteForceReload, recipe: recipe)) {
                Image(systemName: "pencil").padding()
                    .imageScale(.large)
                    .animation(.easeInOut)
                    .padding()
            })
        .navigationTitle(recipe.name!)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func changeMeasurement(type: String) {
        switch type {
        case "Metric":
            currentItems = metItems
        case "Imperial":
            currentItems = impItems
        case "US":
            currentItems = usItems
        default:
            currentItems = metItems
        }
    }
    
    private func convertAmount(convStr: String, convRatio: Double) -> String {
        let rc = convStr.replacingOccurrences(of: ",", with: ".")
        if var decimalValue = Double(rc) {
            decimalValue *= convRatio
            return String(format: "%.2f", decimalValue)
        }
        return "*"
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
    
    private func setUpIngrediens() {
        var metConvErr = false
        var impConvErr = false
        var usConvErr = false
        
        metItems.removeAll()
        impItems.removeAll()
        usItems.removeAll()

        for rI in filteredRecipeItems {
            switch rI.recipeItemToUnit!.unitToUnitType!.unitTypeName {
            case "Metric":
                metItems.append(ItemRow(name: rI.itemDescription!, amount: rI.amount!, unit: rI.recipeItemToUnit!.unitAbbreviation!))
                
                var amount = convertAmount(convStr: rI.amount!, convRatio: Double(truncating: rI.recipeItemToUnit!.toImp!))
                if amount == "*" {
                    impConvErr = true
                }
                impItems.append(ItemRow(name: rI.itemDescription!, amount: amount, unit: rI.recipeItemToUnit!.toImpStr!))
                
                amount = convertAmount(convStr: rI.amount!, convRatio: Double(truncating: rI.recipeItemToUnit!.toUS!))
                if amount == "*" {
                    usConvErr = true
                }
                usItems.append(ItemRow(name: rI.itemDescription!, amount: amount, unit: rI.recipeItemToUnit!.toUSStr!))
            case "Imperial":
                impItems.append(ItemRow(name: rI.itemDescription!, amount: rI.amount!, unit: rI.recipeItemToUnit!.unitAbbreviation!))
                
                var amount = convertAmount(convStr: rI.amount!, convRatio: Double(truncating: rI.recipeItemToUnit!.toMet!))
                if amount == "*" {
                    metConvErr = true
                }
                metItems.append(ItemRow(name: rI.itemDescription!, amount: amount, unit: rI.recipeItemToUnit!.toMetStr!))
                
                amount = convertAmount(convStr: rI.amount!, convRatio: Double(truncating: rI.recipeItemToUnit!.toUS!))
                if amount == "*" {
                    usConvErr = true
                }
                usItems.append(ItemRow(name: rI.itemDescription!, amount: amount, unit: rI.recipeItemToUnit!.toUSStr!))
            case "US":
                usItems.append(ItemRow(name: rI.itemDescription!, amount: rI.amount!, unit: rI.recipeItemToUnit!.unitAbbreviation!))

                var amount = convertAmount(convStr: rI.amount!, convRatio: Double(truncating: rI.recipeItemToUnit!.toMet!))
                if amount == "*" {
                    metConvErr = true
                }
                metItems.append(ItemRow(name: rI.itemDescription!, amount: amount, unit: rI.recipeItemToUnit!.toMetStr!))
                
                amount = convertAmount(convStr: rI.amount!, convRatio: Double(truncating: rI.recipeItemToUnit!.toImp!))
                if amount == "*" {
                    impConvErr = true
                }
                impItems.append(ItemRow(name: rI.itemDescription!, amount: amount, unit: rI.recipeItemToUnit!.toImpStr!))
            default:
                metItems.append(ItemRow(name: rI.itemDescription!, amount: rI.amount!, unit: rI.recipeItemToUnit!.unitAbbreviation!))
                impItems.append(ItemRow(name: rI.itemDescription!, amount: rI.amount!, unit: rI.recipeItemToUnit!.unitAbbreviation!))
                usItems.append(ItemRow(name: rI.itemDescription!, amount: rI.amount!, unit: rI.recipeItemToUnit!.unitAbbreviation!))
            }
        }
        if metConvErr {
            metItems.append(ItemRow(name: "* - cant convert. pls use decimal-format", amount: "", unit: ""))
        }
        if impConvErr {
            impItems.append(ItemRow(name: "* - cant convert. pls use decimal-format", amount: "", unit: ""))
        }
        if usConvErr {
            usItems.append(ItemRow(name: "* - cant convert. pls use decimal-format", amount: "", unit: ""))
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

struct ItemRow: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var amount: String
    var unit: String
}

//struct RecipeDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeListView()
//    }
//}
