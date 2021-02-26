//
//  BrewDetailView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-26.
//

import SwiftUI

struct BrewDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Brew.timestamp, ascending: false)], animation: .default)
    private var brews: FetchedResults<Brew>
    @FetchRequest(entity: BrewType.entity(), sortDescriptors: [], animation: .default)
    private var brewTypes: FetchedResults<BrewType>


    var body: some View {
        Text("Hello, World!")
    }
}

struct BrewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BrewDetailView()
    }
}
