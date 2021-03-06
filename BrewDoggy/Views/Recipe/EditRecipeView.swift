//
//  EditRecipeView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-11.
//

import SwiftUI

struct EditRecipeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = ViewModel()

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.timestamp, ascending: true)], animation: .default)
    private var recipies: FetchedResults<Recipe>
    @FetchRequest(entity: BrewType.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BrewType.timestamp, ascending: false)], animation: .default)
    private var brewTypes: FetchedResults<BrewType>
    @FetchRequest(entity: RecipeItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \RecipeItem.sortId, ascending: true)], animation: .default)
    private var recipeItems: FetchedResults<RecipeItem>
    @FetchRequest(entity: UnitType.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \UnitType.unitTypeSort, ascending: true)],
                  predicate: NSPredicate(format: "unitTypeSort > 0"), animation: .default)
    private var unitTypes: FetchedResults<UnitType>
    @FetchRequest(entity: Unit.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Unit.timestamp, ascending: true)], animation: .default)
    private var units: FetchedResults<Unit>

    @State private var title = "Add a new Recipe"               // NavigationBar title
    @State private var name = ""                                // Container for Recipe name
    @State private var instructions = ""                        // Container for recipe instructions
    @State private var currentItems: [RecipeItem] = []          // Array of original ingredients
    @State private var prevUnitType = ""                        // Keep trac of previous measurement system. To know how to convert
    @State private var showChangeAlert = false                  // Activate Alert not to exit without save
    @State private var showUnitChangeAlert = false              // Activate Alert that measurement system has been changed
    @State private var selectedUnitType = ""                    // Container for selected measurement system
    @State private var showUnitTypePicker = false               // Activate measurement system picker
    @State private var uTypes: [String] = []                    // Array of Strings for "Metric", "Imperial" and "US"
    @State private var showBrewTypePicker = false               // Activate brewtype picker
    @State private var selectedBrewType = ""                    // Container for selected brewtype
    @State private var bTypes: [String] = []                    // Array with strings of available brewtypes
    @State var ingredientItems = [ItemRow(name: "dummy", amount: "dummy", unit: "dummy")]   // Array of selected ingredients
    @State private var changed = false                          // Keep trac if something change to give without save warning
    @State private var firstTime = true                         // Keep trac if its the first time OnAppear runs
    @Binding var isSet: Bool                                    // Make change on binding to force reload of previous views
    
    var recipe: Recipe?                                         // The Recipe Object to be edited
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 5.0) {
                Button(action: {
                    viewModel.choosePhoto()
                    changed = true
                }, label: {
                    VStack(alignment: .center) {
                        Image(uiImage: viewModel.selectedImage ?? UIImage(named: "LTd5gaBKcTextTrans")!)
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
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                if changed {
                    showChangeAlert = true
                } else {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                HStack{
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }, trailing: Image(systemName: "camera")
                .foregroundColor(.blue)
                .onTapGesture { viewModel.takePhoto() }
                .imageScale(.large)
                .animation(.easeInOut)
                .padding())
            .navigationBarTitle("\(title)",displayMode: .inline)
            .fullScreenCover(isPresented: $viewModel.isPresentingImagePicker) {
                ImagePicker(sourceType: viewModel.sourceType, completionHandler: viewModel.didSelectImage)
            }
            .alert(isPresented: $showUnitChangeAlert) {
                Alert(title: Text("Ingredients changed"),
                      message: Text("Ingredients has changed to \(selectedUnitType) System, but the amounts are NOT converted. Please Check!"),
                      dismissButton: .cancel())
            }

            VStack(alignment: .leading) {
                HStack {
                    Text("Name:")
                        .bold()
                    TextField("Name of recipe", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: name) {dummy in
                            changed = true
                        }
                }
                .padding(.horizontal, 15)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)

                HStack {
                    HStack {
                        Text("Type:")
                            .bold()
                        Button(selectedBrewType){
                            convertUnits()
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
                        changed = true
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
                        changed = true
                        convertUnits()
                        self.showUnitTypePicker.toggle()
                    }
                }

                VStack {
                    HStack {
                        Spacer()
                        Text("Ingredients:")
                            .bold()
                        Spacer()
                    }
                    ForEach(ingredientItems) {rI in
                        HStack {
                            Text("\(rI.name)")
                            Spacer()
                            Text("\(rI.amount)")
                            Text("\(rI.unit)")
                        }
                    }
                    NavigationLink(destination: IngredientsView(ingredientItems: $ingredientItems, changed: $changed, unitType: selectedUnitType)) {
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
                        .onChange(of: instructions) {dummy in
                            changed = true
                        }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)

                HStack {
                    Spacer()
                    Button(action: { saveRecipe() }) {
                        Text("Save")
                            .font(.title)
                            .bold()
                    }
                    Spacer()
                }
                .padding(.bottom, 50)
                
            }
            .padding(.horizontal, 15)
            .alert(isPresented: $showChangeAlert) {
                Alert(title: Text("Forgot to save?"),
                      message: Text("Do you want to save before exit?"),
                      primaryButton: .default(Text("Yes")) { saveRecipe() },
                      secondaryButton: .cancel(Text("No")) { self.presentationMode.wrappedValue.dismiss() })
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
            if firstTime {
                firstTime = false
                name = r.name!
                title = "Edit recipe"
                viewModel.selectedImage = UIImage(data: r.picture!)!
                instructions = r.instructions!
                if selectedBrewType == "" { selectedBrewType = r.recipeToBrewType!.typeDescription! }
                if selectedUnitType == "" { selectedUnitType = r.recipeToUnitType!.unitTypeName! }
                currentItems = recipeItems.filter { rI in
                        (rI.recipeItemToRecipe == r)
                }
            }
        }
        if ingredientItems.count == 1 {
            if ingredientItems[0].unit == "dummy" {
                prevUnitType = selectedUnitType
                ingredientItems.removeAll()
                for rI in currentItems {
                    ingredientItems.append(ItemRow(name: rI.itemDescription!, amount: rI.amount!, unit: rI.recipeItemToUnit!.unitAbbreviation!))
                }
            }
        }
        if selectedBrewType == "" { selectedBrewType = "Beer" }
        if selectedUnitType == "" { selectedUnitType = "Metric" }
    }
    
    private func saveRecipe() {
        if let r = recipe {
            r.name = name
            r.instructions = instructions
            r.picture = viewModel.selectedImage?.jpegData(compressionQuality: 1.0)
            r.recipeToBrewType = getBrewType(str: selectedBrewType)
            r.recipeToUnitType = getUnitType(str: selectedUnitType)
            r.timestamp = Date()
            saveViewContext()

            var deleteList: [RecipeItem] = []
            for rI in recipeItems {
                if rI.recipeItemToRecipe == r {
                    deleteList.append(rI)
                }
            }
            for dl in deleteList {
                viewContext.delete(dl)
            }
            saveViewContext()

            var sortID = 1
            for iI in ingredientItems {
                let newItem = RecipeItem(context: viewContext)
                newItem.id = UUID()
                newItem.itemDescription = iI.name
                newItem.amount = iI.amount
                newItem.sortId = Int64(sortID)
                sortID += 1
                newItem.recipeItemToUnit = getUnit(str: iI.unit)
                newItem.recipeItemToRecipe = r
                saveViewContext()
            }
        }
        isSet.toggle()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    // Get database unit from string
    private func getUnit(str: String) -> Unit? {
        var lastUnit: Unit? = nil

        for unit in units {
            if (unit.unitToUnitType!.unitTypeName == selectedUnitType || unit.unitToUnitType!.unitTypeName == "All") &&
                unit.unitAbbreviation! == str {
                return unit
            }
            lastUnit = unit
        }
        return lastUnit
    }
    
    // Get database brewtype from string
    private func getBrewType(str: String) -> BrewType? {
        var lastBT: BrewType? = nil
        for bt in brewTypes {
            if bt.typeDescription == str { return bt}
            lastBT = bt
        }
        
        return lastBT
    }
    
    // Get database unittype from string
    private func getUnitType(str: String) -> UnitType? {
        var lastUT: UnitType? = nil
        for ut in unitTypes {
            if ut.unitTypeName == str { return ut}
            lastUT = ut
        }
        
        return lastUT
    }
    
    // Convert units between measuremant systems - hard coded!!
    private func convertUnits() {
        let mets = ["l", "dl", "ml", "kg", "g"]
        let imps = ["gal", "pt", "fl.oz", "lb", "oz"]
        var anyThindChange = false

        if prevUnitType != selectedUnitType {
            if prevUnitType == "Metric" {
                for i in 0..<mets.count {
                    for iI in 0..<ingredientItems.count {
                        if ingredientItems[iI].unit == mets[i] {
                            ingredientItems[iI].unit = imps[i]
                            anyThindChange = true
                        }
                    }
                }
            } else if selectedUnitType == "Metric" {
                for i in 0..<imps.count {
                    for iI in 0..<ingredientItems.count {
                        if ingredientItems[iI].unit == imps[i] {
                            ingredientItems[iI].unit = mets[i]
                            anyThindChange = true
                        }
                    }
                }
            }
        }
        
        if anyThindChange {
            showUnitChangeAlert = true
        }
        prevUnitType = selectedUnitType
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

//struct EditRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRecipeView()
//    }
//}
