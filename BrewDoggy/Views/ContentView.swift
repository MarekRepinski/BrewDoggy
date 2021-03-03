//
//  ContentView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-07.
//

import SwiftUI
import CoreData
import CodeScanner

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: BrewType.entity(), sortDescriptors: [], animation: .default)
    private var brewTypes: FetchedResults<BrewType>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Brew.timestamp, ascending: false)], animation: .default)
    private var brews: FetchedResults<Brew>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WineCellar.timestamp, ascending: false)], animation: .default)
    private var stores: FetchedResults<WineCellar>

    @State private var opacity = 1.0                    // Opacity of splash image
    @State private var showMeny = false                 // Show meny after splash image
    @State private var recipeGo = false                 // Activate RecipeList NavLink
    @State private var brewGo = false                   // Activate BrewList NavLink
    @State private var wineCellarGo = false             // Activate WineCellar NavLink
    @State private var scanGo = false                   // Activate Scan-Sheet
    @State private var firstTime = true                 // Check if onAppear run for first time then activate splash image animation
    @State private var scanFailed = false               // Open Scan Failure Alert
    @State private var scanNotFound = false             // Open Scan ID not found Alert
    @State private var outBrew: Brew? = nil             // Container if scan ID found a brew
    @State private var outStore: WineCellar? = nil      // Container if scan ID found a winecellar
    @State private var jumpToBrew = false               // Activate a NavLink if scan ID found a brew
    @State private var jumpToCellar = false             // Activate a NavLink if scan ID found a winecellar

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

                        NavigationLink(destination: WineCellarListView(), isActive: $wineCellarGo) {
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
                        .alert(isPresented: $scanNotFound) {
                            Alert(title: Text("Scanned ID not found"),
                                  message: Text("The scanned ID not found in the database."),
                                  dismissButton: .cancel())

                        }

                        HStack {
                            Image("qrCodeHeader")
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                .overlay(RoundedRectangle(cornerRadius: 25.0).stroke(Color.white, lineWidth: 8))
                                .frame(width: 100, height: 80, alignment: .leading)

                            Text("Scan")
                                .foregroundColor(.blue)
                                .font(.title)
                                .bold()
                                .padding()
                            
                            Spacer()
                        }
                        .padding(.init(top: 5, leading: 60, bottom: 5, trailing: 30))
                        .contentShape(Rectangle())
                        .background(Color.white).opacity(0.8)
                        .onTapGesture {
                            scanGo = true
                        }
                        .alert(isPresented: $scanFailed) {
                            Alert(title: Text("Scan Failed"),
                                  message: Text("Either the QR-code is bad or the Scanner is not working"),
                                  dismissButton: .cancel())

                        }

                        Spacer()
                    }
                }
                NavigationLink(destination: BrewDetailView(brew: outBrew ?? brews[0]),
                               isActive: $jumpToBrew) { EmptyView() }.hidden()
                NavigationLink(destination: WineCellarDetailView(store: outStore ?? stores[0]),
                               isActive: $jumpToCellar) { EmptyView() }.hidden()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .background(Color.white)
            .ignoresSafeArea()
            .onAppear() {
                if brewTypes.count == 0 {
                    _ = MockData(context: viewContext)
                }
                if firstTime {
                    firstTime = false
                    let _delay = RunLoop.SchedulerTimeType(.init(timeIntervalSinceNow: 3))
                    RunLoop.main.schedule(after: _delay) {
                        withAnimation(Animation.easeInOut(duration: 2)){
                            opacity = 0.08
                            showMeny = true
                        }
                    }
                } else {
                    if modelData.flush {
                        modelData.flush = false
                        if modelData.recipeGo {
                            modelData.recipeGo = false
                            recipeGo = true
                        }
                        if modelData.brewGo {
                            modelData.brewGo = false
                            brewGo = true
                        }
                        if modelData.wineCellarGo {
                            modelData.wineCellarGo = false
                            wineCellarGo = true
                        }
                    }
                }
            }
            .sheet(isPresented: $scanGo) {
                CodeScannerView(codeTypes: [.qr], simulatedData: brews[0].id?.uuidString ?? "Brew not found", completion: self.handleScan)
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
        // Animate splash image
        withAnimation(Animation.easeInOut(duration: 1)){
            opacity = 0.08
            showMeny = true
        }
    }
    
    private func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        // Handle result from scanner
        scanGo = false
        
        switch result {
        case .success(let code):
            for brew in brews {
                if brew.id?.uuidString == code {
                    outBrew = brew
                    jumpToBrew = true
                }
            }
            for store in stores {
                if store.id?.uuidString == code {
                    outStore = store
                    jumpToCellar = true
                }
            }

        case .failure( _):
            scanFailed = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
