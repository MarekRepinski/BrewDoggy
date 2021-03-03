//
//  ModelData.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-03-01.
//

import Foundation
import SwiftUI

class ModelData: ObservableObject {
    @Published var flush: Bool = false      // Flush Navigation History back to Top level
    @Published var recipeGo = false         // Activate RecipeList NavLink in ContentView
    @Published var brewGo = false           // Activate BrewList NavLink in ContentView
    @Published var wineCellarGo = false     // Activate WineCellarList NavLink in ContentView
}
