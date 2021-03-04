//
//  AddWineCellarView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-03-02.
//

import SwiftUI

struct AddWineCellarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modelData: ModelData
    @StateObject var viewModel = ViewModel()

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.timestamp, ascending: true)], animation: .default)
    private var recipies: FetchedResults<Recipe>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Brew.timestamp, ascending: false)], animation: .default)
    private var brews: FetchedResults<Brew>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WineCellar.timestamp, ascending: false)], animation: .default)
    private var stores: FetchedResults<WineCellar>

    @State private var title = "Add a new Storage"              // Container for NavigationBar title
    @State private var name = ""                                // Container for Name
    @State private var bottles = 12                             // Container for start no of bottles in store
    @State private var comment = ""                             // Container for Comment
    @State private var brewList: [String] = []                  // Array with strings of available brews
    @State private var brew: Brew? = nil                        //*** Is this really used here????? Brew object store is linked to
    @State private var selectedBrew = "*not* homebrewed"        // Container for selected Brew
    
    @State private var showChangeAlert = false                  // Activate Alert not to exit without save
    @State private var showBrewPicker = false                   // Activate Brew picker
    @State private var showBottlesPicker = false                // Activate no of bottles picker
    @State private var changed = false                          // Keep trac if something change to give without save warning
    @State private var outStore: WineCellar? = nil              // Container for new WineCellar Objcet after save, used to call WineCellarDetail
    @State private var saveAndMoveOn = false                    // Activate WineCellarDetail
    @State private var firstTime = true                         // Check if onAppear run for first time for setUpStates()
    @Binding var isSet: Bool                                    // Make change on binding to force reload of previous views
    
    var maxNoOfBottles: Int = 144                               // Max no of bottles in Store

    var body: some View {
        ScrollView {
            NavigationLink(destination: WineCellarDetailView(
                            store: outStore ?? stores[0],
                            flushAfter: true),
                            isActive: $saveAndMoveOn) { EmptyView() }.hidden()

            VStack(alignment: .center, spacing: 5.0) {
                Button(action: {
                    viewModel.choosePhoto()
                    changed = true
                }, label: {
                    VStack(alignment: .center) {
                        Image(uiImage: viewModel.selectedImage ?? UIImage(named: "LTd5gaBKcTextTrans")!)
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 200)
                            .cornerRadius(15)
                        
                        Text("Tap to change")
                            .foregroundColor(.blue)
                            .font(.footnote)
                    }
                })
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
            }
            .padding(.init(top: 20, leading: 0, bottom: 5, trailing: 0))
            .onAppear(){
                if modelData.flush {
                    self.presentationMode.wrappedValue.dismiss()
                }
                setUpStates()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                if changed {
                    showChangeAlert = true
                } else {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                HStack{
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }, trailing: Image(systemName: "camera")
                .foregroundColor(.blue)
                .onTapGesture { viewModel.takePhoto() }
                .imageScale(.large)
                .animation(.easeInOut)
                .padding())
            .navigationBarTitle("\(title)",displayMode: .inline)
            .fullScreenCover(isPresented: $viewModel.isPresentingImagePicker) {
                ImagePicker(sourceType: viewModel.sourceType, completionHandler: viewModel.didSelectImage)
            }
            .alert(isPresented: $showChangeAlert) {
                Alert(title: Text("Forgot to save?"),
                      message: Text("Do you want to save before exit?"),
                      primaryButton: .default(Text("Yes")) { saveStore() },
                      secondaryButton: .cancel(Text("No")) { self.presentationMode.wrappedValue.dismiss() })
            }

            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("Name:")
                        .bold()
                    TextField("Name of brew", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: name) {dummy in
                            changed = true
                        }
                    Spacer()
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)
                .padding(.horizontal, 15)

                HStack {
                    Text("Number of tasted bottles:")
                        .bold()

                    Spacer()

                    Button(action: { self.showBottlesPicker.toggle() }){
                        Text("\(bottles)")

                    }

                    Spacer()
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .onTapGesture {
                    self.showBottlesPicker.toggle()
                }

                if showBottlesPicker {
                    Picker("", selection: $bottles) {
                        ForEach(0..<(maxNoOfBottles + 1)) {
                            if $0 > 0 {
                                Text($0 > 1 ? "\($0) bottles" : "\($0) bottle")
                            }
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                    .onTapGesture {
                        changed = true
                        self.showBottlesPicker.toggle()
                    }
                }

                HStack {
                    Text("From Brew:")
                        .bold()
                    Button(selectedBrew){
                        self.showBrewPicker.toggle()
                    }
                    Spacer()
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)
                .padding(.horizontal, 15)

                if showBrewPicker {
                    Picker("Recipe Type", selection: $selectedBrew) {
                        ForEach(brewList, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                    .onTapGesture {
                        changed = true
                        self.showBrewPicker.toggle()
                    }
                }
                
                VStack(alignment: .center, spacing: 10) {
                    Text("Comment:")
                        .bold()
                    TextEditor(text: $comment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 100)
                        .onChange(of: comment) {dummy in
                            changed = true
                        }
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)
                .padding(.horizontal, 15)

                HStack {
                    Spacer()
                    Button(action: { saveStore() }) {
                        Text("Save")
                            .font(.title)
                            .bold()
                    }
                    Spacer()
                }
                
            }
            .padding(.horizontal, 15)
        }
    }
    
    private func setUpStates() {
        if firstTime {
            brewList.removeAll()
            brewList.append(selectedBrew)
            for b in brews {
                brewList.append(b.name!)
            }
            firstTime = false
        }
    }
    
    private func saveStore() {
        let newStore = WineCellar(context: viewContext)
        newStore.id = UUID()
        if name == "" { name = "Secret Storage" }
        newStore.name = name
        if let pic = viewModel.selectedImage {
            newStore.picture = pic.jpegData(compressionQuality: 1.0)
        } else {
            newStore.picture = UIImage(named: "LTd5gaBKcTextTrans")!.jpegData(compressionQuality: 1.0)
        }
        newStore.start = Date()
        newStore.timestamp = Date()
        newStore.bottlesStart = Int64(bottles)
        newStore.comment = comment
        newStore.isNotDrunk = false
        if let b = findBrew() {
            newStore.wineCellarToBrew = b
            newStore.qrID = b.id
        } else {
            newStore.qrID = UUID()
        }
        saveViewContext()

        outStore = newStore

        isSet.toggle()
        saveAndMoveOn = true
    }
    
    // Find Brew object with selectedBrew(name)
    private func findBrew() -> Brew? {
        for b in brews {
            if selectedBrew == b.name {
                return b
            }
        }
        return nil
    }
    
    private func saveViewContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

//struct AddWineCellarView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddWineCellarView()
//    }
//}
