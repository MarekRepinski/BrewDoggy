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
    @FetchRequest(entity: BrewType.entity(), sortDescriptors: [], animation: .default)
    private var brewTypes: FetchedResults<BrewType>

    @State private var opacity = 1.0
    @State private var showMeny = false
    @State private var recipeGo = false
    @State private var brewGo = false
    @State private var wineCellarGo = false
    @State private var scanGo = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                VStack(alignment: .center) {
                    Image("LTd5gaBKcTextTrans")
                        .resizable()
                        .frame(width: 300, height: 500)
                        .opacity(opacity)
                        .onTapGesture { enterApp() }
                        .padding(.init(top: 100, leading: 10, bottom: 5, trailing: 10))
                    
                    Spacer()
                }
                if showMeny {
                    VStack {
                        Spacer()

                        Text("Brew Doggy")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                        NavigationLink(destination: RecipeListView(), isActive: $recipeGo) {
                            HStack {
                                Image("RecipePic")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                    .overlay(RoundedRectangle(cornerRadius: 25.0).stroke(Color.white, lineWidth: 8))
                                    .frame(width: 100, height: 80, alignment: .leading)

                                Text("Recipies")
                                    .font(.title)
                                    .bold()
                                    .padding()
                            }
                            .padding(.init(top: 5, leading: 60, bottom: 5, trailing: 30))
                            .contentShape(Rectangle())
                            .background(Color.white).opacity(0.8)

                            Spacer()
                        }

                        NavigationLink(destination: BrewListView(), isActive: $brewGo) {
                            HStack {
                                Image("brewHeader")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                    .overlay(RoundedRectangle(cornerRadius: 25.0).stroke(Color.white, lineWidth: 8))
                                    .frame(width: 100, height: 80, alignment: .leading)

                                Text("Brews")
                                    .font(.title)
                                    .bold()
                                    .padding()
                            }
                            .padding(.init(top: 5, leading: 60, bottom: 5, trailing: 30))
                            .contentShape(Rectangle())
                            .background(Color.white).opacity(0.8)

                            Spacer()
                        }

                        NavigationLink(destination: EmptyView()) {
                            HStack {
                                Image("wineCellar")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                    .overlay(RoundedRectangle(cornerRadius: 25.0).stroke(Color.white, lineWidth: 8))
                                    .frame(width: 100, height: 80, alignment: .leading)

                                Text("Wine Cellar")
                                    .font(.title)
                                    .bold()
                                    .padding()
                            }
                            .padding(.init(top: 5, leading: 60, bottom: 5, trailing: 30))
                            .contentShape(Rectangle())
                            .background(Color.white).opacity(0.8)

                            Spacer()
                        }

                        NavigationLink(destination: EmptyView()) {
                            HStack {
                                Image("qrCodeHeader")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                    .overlay(RoundedRectangle(cornerRadius: 25.0).stroke(Color.white, lineWidth: 8))
                                    .frame(width: 100, height: 80, alignment: .leading)

                                Text("Scan")
                                    .font(.title)
                                    .bold()
                                    .padding()
                            }
                            .padding(.init(top: 5, leading: 60, bottom: 5, trailing: 30))
                            .contentShape(Rectangle())
                            .background(Color.white).opacity(0.8)

                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .background(Color.white)
            .ignoresSafeArea()
            .onAppear() {
                if brewTypes.count == 0 {
                    _ = MockData(context: viewContext)
                }
                let _delay = RunLoop.SchedulerTimeType(.init(timeIntervalSinceNow: 3))
                RunLoop.main.schedule(after: _delay) {
                    withAnimation(Animation.easeInOut(duration: 2)){
                        opacity = 0.08
                        showMeny = true
                    }
                    
                }
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()

                    VStack {
                        Image(systemName: "scroll.fill")
                            .foregroundColor(Color(.blue))
                            .imageScale(.large)
                        Text("Recipe")
                            .foregroundColor(Color(.blue))
                            .font(.footnote)
                            .bold()
                    }
                    .onTapGesture {
                        recipeGo = true
                    }

                    Spacer()

                    VStack {
                        Image(systemName: "thermometer")
                            .foregroundColor(Color(.blue))
                            .imageScale(.large)
                        Text("Brew")
                            .foregroundColor(Color(.blue))
                            .font(.footnote)
                            .bold()
                    }
                    .onTapGesture {
                        brewGo = true
                    }

                    Spacer()

                    VStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color(.blue))
                            .imageScale(.large)
                        Text("Cellar")
                            .foregroundColor(Color(.blue))
                            .font(.footnote)
                            .bold()
                    }
                    .onTapGesture {
                        wineCellarGo = true
                    }

                    Spacer()

                    VStack {
                        Image(systemName: "barcode.viewfinder")
                            .foregroundColor(Color(.blue))
                            .imageScale(.large)
                        Text("Scan")
                            .foregroundColor(Color(.blue))
                            .font(.footnote)
                            .bold()
                    }
                    .onTapGesture {
                        scanGo = true
                    }

                    Spacer()
                }
            }
        }
    }
    
    private func enterApp() {
        withAnimation(Animation.easeInOut(duration: 1)){
            opacity = 0.08
            showMeny = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
