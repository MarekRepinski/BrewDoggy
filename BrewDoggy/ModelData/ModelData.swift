//
//  ModelData.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-03-01.
//

import Foundation
import SwiftUI

class ModelData: ObservableObject {
    @Published var flush: Bool = false
    @Published var isPresentingImagePicker = false
    @Published var recipeGo = false
    @Published var brewGo = false
    @Published var wineCellarGo = false
}
