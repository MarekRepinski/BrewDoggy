//
//  WineCellarListView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-03-02.
//

import SwiftUI

struct WineCellarListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WineCellar.timestamp, ascending: false)], animation: .default)
    private var stores: FetchedResults<WineCellar>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Taste.date, ascending: true)], animation: .default)
    private var tastes: FetchedResults<Taste>
    
    @State private var showNotEmptyOnly = false
    @State private var bruteForceReload = false
    @State private var askBeforeDelete = false
    @State private var cantBeDeleted = false
    @State private var editIsActive = false
    @State private var isAddActive = false
    @State private var deleteOffSet: IndexSet = [0]
    
    var filteredStores: [WineCellar] {
        stores.filter { s in
            (!showNotEmptyOnly || s.isNotDrunk)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showNotEmptyOnly) {
                    Text("Not Empty only")
                }
                ForEach(filteredStores) { store in
                    NavigationLink(destination: WineCellarDetailView(isAddActive: $isAddActive, store: store)) {
                        HStack {
                            Image(uiImage: UIImage(data: store.picture!)!)
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                            
                            Text("\(getSubstring(s: store.name!))")
                            
                            Spacer()
                            
                            Text("\(bottlesLeft(store: store))")
                            
                            Image(bottlesLeftIcon(store: store))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        }
                        .contentShape(Rectangle())                    }
                }
                .onDelete(perform: onDelete)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Your Wine Stores:")
            .navigationBarItems(leading:
                                    Button(action: {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }) {
                                        HStack{
                                            Image(systemName: "chevron.left")
                                            Text("Back")
                                        }
                                    }, trailing:
                                        Button(action: { editIsActive = true}) {
                                            Image(systemName: "plus")
                                                .imageScale(.large)
                                                .padding()
                                        }
            )
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    VStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(Color(.blue))
                            .imageScale(.large)
                        Text("Home")
                            .foregroundColor(Color(.blue))
                            .font(.footnote)
                            .bold()
                    }
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .alert(isPresented: $askBeforeDelete) {
                        Alert(title: Text("Deleting a Wine Store"),
                              message: Text("This action can not be undone. Are you really sure?"),
                              primaryButton: .default(Text("Yes")) { deleteStore() },
                              secondaryButton: .cancel(Text("No")))
                    }
                    
                    Spacer()
//                    NavigationLink(destination: AddBrewView(isSet: $bruteForceReload, isAddActive: $editIsActive),
//                                   isActive: $editIsActive) { EmptyView() }.hidden()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func onDelete(offsets: IndexSet) {
        deleteOffSet = offsets
        if deletableStore() { askBeforeDelete = true }
        else { cantBeDeleted = true }
    }
    
    private func deletableStore() -> Bool {
        for index in deleteOffSet {
            for taste in tastes {
                if taste.tasteToWineCellar == filteredStores[index] { return false }
            }
        }
        return true
    }
    
    private func deleteStore() {
        withAnimation {
            deleteOffSet.map { filteredStores[$0] }.forEach(viewContext.delete)
        }
        askBeforeDelete = false
        saveViewContext()
    }
    
    private func saveViewContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func bottlesLeft(store: WineCellar) -> Int {
        var rc = store.bottlesStart
        for taste in tastes {
            if taste.tasteToWineCellar == store {
                rc -= taste.bottles
            }
        }

        return Int(rc)
    }
    
    private func bottlesLeftIcon(store: WineCellar) -> String {
        let bottles = bottlesLeft(store: store)
        switch bottles {
        case 0:
            return "winBottle0"
            
        case 1:
            return "winBottle1"
            
        case 2:
            return "winBottle2"
            
        case 3:
            return "winBottle3"
            
        case 4:
            return "winBottle4"
            
        default:
            return "winBottle5"
        }
    }

    private func getSubstring(s: String) -> String {
        var rc = s

        if s.count > 20 {
            let end = s.index(s.startIndex, offsetBy: 17)
            rc = String(s[s.startIndex..<end]) + "..."
        }
        return rc
    }
}

struct WineCellarListView_Previews: PreviewProvider {
    static var previews: some View {
        WineCellarListView()
    }
}
