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
    @State private var selectedUnit = "Tbsp"
    @State private var showAddIngredient = false
    @State private var showUndoButton = false
    @State private var pickerVisible = false
    @State private var editMode = EditMode.inactive
    @State private var orgItems: [ItemRow] = []
    @State private var currIndex = -1
    @Binding var ingredientItems: [ItemRow]
    @Binding var changed: Bool
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
                    editMode = EditMode.inactive
                    pickerVisible = false
                }
            }
            NavigationView {
                List {
                    ForEach(0..<ingredientItems.count, id:\.self) {index in
                        HStack {
                            Text("\(ingredientItems[index].name)")
                            Spacer()
                            Text("\(ingredientItems[index].amount)")
                            Text("\(ingredientItems[index].unit)")
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showAddIngredient = true
                            self.currIndex = index
                            ingredient = ingredientItems[index].name
                            amount = ingredientItems[index].amount
                            selectedUnit = ingredientItems[index].unit
                        }
                    }
                    .onDelete(perform: onDelete)
                    .onMove(perform: onMove)
                }
                .navigationBarTitle("Edit Ingredients:",displayMode: .inline)
                .navigationBarItems(leading: EditButton(), trailing: addButton)
                .environment(\.editMode, $editMode)
                .onAppear() {
                    if orgItems.isEmpty { orgItems = ingredientItems }
                }
            }
            if showUndoButton {
                Button("Undo changes") {
                    ingredientItems = orgItems
                    showUndoButton = false
                }.padding()
            }
        }
    }
    
    private func saveUpdateItem() {
        if currIndex == -1 {
            let newItemRow = ItemRow(id: UUID(), name: ingredient, amount: amount, unit: selectedUnit)
            ingredientItems.append(newItemRow)
        } else {
            ingredientItems[currIndex].name = ingredient
            ingredientItems[currIndex].amount = amount
            ingredientItems[currIndex].unit = selectedUnit
        }
        showAddIngredient = false
        ingredient = ""
        amount = ""
        selectedUnit = "Tbsp"
        currIndex = -1
        showUndoButton = true
        changed = true
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        ingredientItems.move(fromOffsets: source, toOffset: destination)
        showUndoButton = true
        changed = true
    }
    
    private func onDelete(offsets: IndexSet) {
        ingredientItems.remove(atOffsets: offsets)
        showAddIngredient = false
        ingredient = ""
        amount = ""
        selectedUnit = "Tbsp"
        currIndex = -1
        showUndoButton = true
        changed = true
    }
    
    private var addButton: some View {
        if !showAddIngredient {
            return AnyView(Button(action: { showAddIngredient = true }) {
                            Image(systemName: "plus")
                                .imageScale(.large)
            })
        } else {
            return AnyView(Button(action: {
                showAddIngredient = false
                ingredient = ""
                amount = ""
                selectedUnit = "Tbsp"
                currIndex = -1
            }) {
                Image(systemName: "minus")
                
            })
        }
    }
}

//struct IngredientsView_Previews: PreviewProvider {
//    static var previews: some View {
//        IngredientsView()
//    }
//}
