//
//  ScanningView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-03-04.
//

import SwiftUI
import CoreData
import CodeScanner

struct ScanningView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: BrewType.entity(), sortDescriptors: [], animation: .default)
    private var brewTypes: FetchedResults<BrewType>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Brew.timestamp, ascending: false)], animation: .default)
    private var brews: FetchedResults<Brew>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WineCellar.timestamp, ascending: false)], animation: .default)
    private var stores: FetchedResults<WineCellar>

    @State private var scanFailed = false               // Open Scan Failure Alert
    @State private var scanNotFound = false             // Open Scan ID not found Alert
    @State private var outBrew: Brew? = nil             // Container if scan ID found a brew
    @State private var outStore: WineCellar? = nil      // Container if scan ID found a winecellar
    @State private var jumpToBrew = false               // Activate a NavLink if scan ID found a brew
    @State private var jumpToCellar = false             // Activate a NavLink if scan ID found a winecellar

    var body: some View {
        VStack {
            CodeScannerView(codeTypes: [.qr], simulatedData: brews[0].id?.uuidString ?? "Brew not found", completion: self.handleScan)
        }
        .alert(isPresented: $scanNotFound) {
            Alert(title: Text("Scanned ID not found"),
                  message: Text("The scanned ID not found in the database."),
                  dismissButton: .cancel())

        }
        VStack {
            NavigationLink(destination: BrewDetailView(brew: outBrew ?? brews[0], flushAfter: true),
                           isActive: $jumpToBrew) { EmptyView() }.hidden()
            NavigationLink(destination: WineCellarDetailView(store: outStore ?? stores[0], flushAfter: true),
                           isActive: $jumpToCellar) { EmptyView() }.hidden()
        }
        .alert(isPresented: $scanFailed) {
            Alert(title: Text("Scan Failed"),
                  message: Text("Either the QR-code is bad or the Scanner is not working"),
                  dismissButton: .cancel())

        }
    }

    private func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        // Handle result from scanner
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

struct ScanningView_Previews: PreviewProvider {
    static var previews: some View {
        ScanningView()
    }
}
