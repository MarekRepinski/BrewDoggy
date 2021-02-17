//
//  AddRecipeView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-08.
//

import SwiftUI

struct AddRecipeView: View {
    @Environment(\.managedObjectContext) private var viewContext
//    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var picture = ""
    @State private var instructions = ""
    

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of recipe", text: $name)
                    TextField("Picture", text: $picture)
                }
                Section {
                    TextField("Instructions", text: $instructions)
                }
                Section {
                    
                }
                Section {
                    Button("Save") {
                        let newRecipe = Recipe(context: viewContext)
                        newRecipe.name = self.name
                        newRecipe.picture = self.picture
                        newRecipe.instructions = self.instructions
                        newRecipe.timestamp = Date()
                        
                        try? self.viewContext.save()
                        
//                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Add a recipe")
        }
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}
