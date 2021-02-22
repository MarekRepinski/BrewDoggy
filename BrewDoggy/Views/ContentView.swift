//
//  ContentView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-07.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                VStack(alignment: .center) {
                    Spacer()
                    Image("LTd5gaBKcTextTrans")
                        .opacity(0.05)
                    Spacer()
                }
                VStack {
                    Spacer()
                    Text("Welcome to")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    Text("Brew Doggy")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    NavigationLink(destination: RecipeListView()) {
                        HStack {
                            Image("recipeHeader")
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                .overlay(RoundedRectangle(cornerRadius: 25.0).stroke(Color.white, lineWidth: 8))
                                .frame(width: 75, height: 75, alignment: .leading)
                            Spacer()
                            Text("Recipies")
                                .font(.title)
                                .bold()
                        }
                        .padding(.init(top: 5, leading: 60, bottom: 5, trailing: 100))
                        .contentShape(Rectangle())
                        .background(Color.white)
                    }
                    Spacer()
                }
            }
            .background(Color.white)
//            .ignoresSafeArea()
        }
//        RecipeListView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
