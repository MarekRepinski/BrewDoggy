//
//  FavoriteButton.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-10.
//

import SwiftUI

// Make a favorite Star with binding and save if changed
struct FavoriteButton: View {
    @Binding var isSet: Bool
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        Button(action: {
            isSet.toggle()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }) {
            Image(systemName: isSet ? "star.fill" : "star")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(isSet ? Color.yellow : Color.gray)
        }
    }
}

//struct FavoriteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeListView()
////        FavoriteButton(isSet: .constant(true))
//    }
//}
