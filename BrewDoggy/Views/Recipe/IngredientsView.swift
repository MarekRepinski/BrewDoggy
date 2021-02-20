//
//  IngredientsView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-20.
//

import SwiftUI

struct IngredientsView : View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Unit.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Unit.timestamp, ascending: true)], animation: .default)
    private var units: FetchedResults<Unit>
    
    @State private var ingredient = ""
    @State private var amount = ""
    @State private var selectedUnit = "Unit"
    @State private var showAddIngredient = false
    @State private var pickerVisible = false
    @State private var editMode = EditMode.inactive
    @State private var orgItems: [RecipeItem] = []
    @State private var currIndex = -1
    @Binding var currentItems: [RecipeItem]
    var unitType: String
    
    var filteredUnits: [String] {
        var rc: [String] = []
        let tempArr = units.filter { u in
            (u.unitToUnitType?.unitTypeSort == 0 || u.unitToUnitType?.unitTypeName == unitType)
        }
        for item in tempArr {
            rc.append(item.unitAbbreviation!)
        }
        return rc
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if showAddIngredient {
                    Divider()
                    HStack(alignment: .center) {
                        TextField("Enter ingredient", text: $ingredient)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                        HStack{
                            TextField("", text: $amount)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .fixedSize()
                            Button(selectedUnit){
                                self.pickerVisible.toggle()
                            }
                        }
                        .padding(.horizontal, 10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                    }.padding(.horizontal, 15)

                    if pickerVisible {
                        Picker("", selection: $selectedUnit) {
                            ForEach(filteredUnits, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(InlinePickerStyle())
                        .onTapGesture {
                            self.pickerVisible.toggle()
                        }
                    }
                    
                    Button(self.currIndex == -1 ? "Add" : "Update") {
                        if ingredient == "" {
                            ingredient = "Unknown ingredient"
                        }
                        if selectedUnit == "Unit" {
                            selectedUnit = "other"
                        }
                        saveUpdateItem()
                        showAddIngredient = false
                    }
                }
                List {
                    ForEach(0..<currentItems.count) {index in
                        HStack {
                            Text("\(currentItems[index].itemDescription!)")
                            Spacer()
                            Text("\(currentItems[index].amount!)")
                            Text("\(currentItems[index].recipeItemToUnit!.unitAbbreviation!)")
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showAddIngredient = true
                            self.currIndex = index
                            ingredient = currentItems[index].itemDescription!
                            amount = currentItems[index].amount!
                            selectedUnit = currentItems[index].recipeItemToUnit!.unitAbbreviation!
                        }
                    }
                    .onDelete(perform: onDelete)
                    .onMove(perform: onMove)
                    //                        .onInsert(of: [String(kUTTypeURL)], perform: onInsert)
                }
                .navigationBarTitle("Edit Ingredients:",displayMode: .inline)
                .navigationBarItems(leading: EditButton(), trailing: addButton)
                .environment(\.editMode, $editMode)
                .onAppear() {
                    print("org has \(orgItems.count) posts")
                    if orgItems.isEmpty {
                        orgItems = currentItems
                        print("Org is set")
                    }
                }
            }
        }
    }
    
    private func saveUpdateItem() {
        print("\(currIndex)")
        if currIndex == -1 {
            let newRecipeItem = RecipeItem(context: viewContext)
            newRecipeItem.itemDescription = self.ingredient
            newRecipeItem.sortId = 0
            newRecipeItem.amount = self.amount
            newRecipeItem.timestamp = Date()
            newRecipeItem.id = UUID()
            newRecipeItem.recipeItemToUnit = findUnit(abbr: selectedUnit)
            currentItems.append(newRecipeItem)

        } else {
            currentItems[currIndex].itemDescription = self.ingredient
            currentItems[currIndex].amount = self.amount
            currentItems[currIndex].timestamp = Date()
            currentItems[currIndex].recipeItemToUnit = findUnit(abbr: selectedUnit)
        }
    }
    
    private func reSortUnits() {
        for index in 0..<currentItems.count {
            currentItems[index].sortId = Int64(index + 1)
        }
    }
    
    private func findUnit(abbr: String) -> Unit? {
        var rc: Unit?
        
        for u in units {
            if u.unitAbbreviation == abbr {
                return u
            }
            if u.unitAbbreviation == "other" {
                rc = u
            }
        }
        return rc
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        currentItems.move(fromOffsets: source, toOffset: destination)
        reSortUnits()
    }
    
    private func onDelete(offsets: IndexSet) {
        currentItems.remove(atOffsets: offsets)
    }
    
    private var addButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: { showAddIngredient = true }) { Image(systemName: "plus") })
        default:
            return AnyView(Button(action: { showAddIngredient = false }) { Image(systemName: "minus") })
        }
    }
}

//struct IngredientsView_Previews: PreviewProvider {
//    static var previews: some View {
//        IngredientsView()
//    }
//}
