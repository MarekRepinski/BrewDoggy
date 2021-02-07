//
//  BrewDoggyApp.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-07.
//

import SwiftUI

@main
struct BrewDoggyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
