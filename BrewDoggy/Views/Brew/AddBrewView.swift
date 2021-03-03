//
//  AddBrewView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-28.
//

import SwiftUI

struct AddBrewView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modelData: ModelData
    @StateObject var viewModel = ViewModel()

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.timestamp, ascending: true)], animation: .default)
    private var recipies: FetchedResults<Recipe>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Brew.timestamp, ascending: false)], animation: .default)
    private var brews: FetchedResults<Brew>
    @FetchRequest(entity: BrewType.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BrewType.timestamp, ascending: false)], animation: .default)
    private var brewTypes: FetchedResults<BrewType>

    @State private var title = "Add a new Brew"
    @State private var name = ""
    @State private var og = ""
    @State private var eta = Date()
    
    @State private var showChangeAlert = false
    @State private var showTypeChangeAlert = false
    @State private var showGravityAlert = false
    @State private var showBrewTypePicker = false
    @State private var selectedBrewType = ""
    @State private var bTypes: [String] = []
    @State private var showRecipePicker = false
    @State private var selectedRecipe = ""
    @State private var rTypes: [String] = []
    @State private var changed = false
    @State private var outBrew: Brew? = nil
    @State private var saveAndMoveOn = false
    @State private var firstTime = true
    @Binding var isSet: Bool
    @Binding var isAddActive: Bool
    
    var recipe: Recipe? = nil
    var flushAfter: Bool = false

    var body: some View {
        ScrollView {
            NavigationLink(destination: BrewDetailView(brew: outBrew ?? brews[0],
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
                      primaryButton: .default(Text("Yes")) { saveBrew() },
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
                .padding(.horizontal, 15)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)

                VStack {
                    HStack {
                        Text("Brew Type:")
                            .bold()
                        Button(selectedBrewType){
                            self.showBrewTypePicker.toggle()
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                    .alert(isPresented: $showTypeChangeAlert) {
                        Alert(title: Text("Brew Types Changed"),
                              message: Text("Your recipe selection is no longer valid. Please chose recipe!"),
                              dismissButton: .cancel())
                    }

                    HStack {
                        Text("Recipe:")
                            .bold()
                        Button(selectedRecipe){
                            self.showRecipePicker.toggle()
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                }
                .padding(.vertical, 5)

                if showBrewTypePicker {
                    Picker("Recipe Type", selection: $selectedBrewType) {
                        ForEach(bTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                    .onTapGesture {
                        changed = true
                        setRecipeList(bt: selectedBrewType)
                        self.showBrewTypePicker.toggle()
                    }
                }
                
                if showRecipePicker {
                    Picker("Recipe", selection: $selectedRecipe) {
                        ForEach(rTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                    .onTapGesture {
                        changed = true
                        self.showRecipePicker.toggle()
                    }
                }

                HStack {
                    Text("Original Gravity:")
                        .bold()
                    TextField("OG", text: $og)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: og) {dummy in
                            changed = true
                        }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)
                .alert(isPresented: $showGravityAlert) {
                    Alert(title: Text("Unclear Gravity"),
                          message: Text("Please enter Gravity between 800 and 1775 or leave it empty. Note: You cant calculate ABV if you leave OG empty!!"),
                          dismissButton: .cancel())
                }

                HStack {
                    DatePicker(selection: $eta, in: Date()..., displayedComponents: .date, label: { Text("ETA:").bold() })
                        .datePickerStyle(CompactDatePickerStyle())
                        .onChange(of: eta, perform: { (value) in
                            changed = true
                        })
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)

                HStack {
                    Spacer()
                    Button(action: { saveBrew() }) {
                        Text("Save")
                            .font(.title)
                            .bold()
                    }
                    Spacer()
                }
                
            }
            .padding(.horizontal, 15)
        }
        .onAppear(){
            if modelData.flush {
                self.presentationMode.wrappedValue.dismiss()
            }
            setUpStates()
        }
    }
    
    private func addForthNight() -> Date {
        let currenDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 14
        return Calendar.current.date(byAdding: dateComponent, to: currenDate)!
    }
    
    private func setUpStates() {
        if firstTime {
            bTypes.removeAll()
            for bt in brewTypes {
                bTypes.append(bt.typeDescription!)
            }

            if let r = recipe {
                selectedBrewType = (r.recipeToBrewType?.typeDescription)!
                selectedRecipe = r.name!
            }
            
            if selectedBrewType == "" {
                selectedBrewType = "Beer"
            }
            setRecipeList(bt: selectedBrewType)
            eta = addForthNight()
            firstTime = false
        }
    }
    
    private func setRecipeList(bt: String) {
        var changedType = true
        
        rTypes.removeAll()
        for rt in recipies {
            if rt.recipeToBrewType?.typeDescription == bt {
                rTypes.append(rt.name!)
                if rt.name == selectedRecipe {
                    changedType = false
                }
            }
        }
        if changedType {
            if selectedRecipe != "" { showTypeChangeAlert = true }
            selectedRecipe = rTypes[0]
        }
    }
    
    private func saveBrew() {
        let g = checkGravity(s: og)
        if g > -1 {
            let newBrew = Brew(context: viewContext)
            newBrew.id = UUID()
            if name == "" { name = "no name Brew" }
            newBrew.name = name
            newBrew.originalGravity = Int64(g)
            newBrew.eta = eta
            newBrew.finalGravity = 0
            newBrew.isDone = false
            newBrew.grade = 0
            if let pic = viewModel.selectedImage {
                newBrew.picture = pic.jpegData(compressionQuality: 1.0)
            } else {
                newBrew.picture = UIImage(named: "LTd5gaBKcTextTrans")!.jpegData(compressionQuality: 1.0)
            }
            newBrew.start = Date()
            newBrew.timestamp = Date()
            newBrew.brewToRecipe = findRecipe()
            newBrew.brewToBrewType = findBrewType()
            saveViewContext()

            outBrew = newBrew

            isSet.toggle()
            saveAndMoveOn = true
        } else {
            showGravityAlert = true
        }
    }
    
    private func checkGravity(s: String) -> Int {
        if s == "" {
            return 0
        }
        var ss = s.replacingOccurrences(of: ",", with: "")
        ss = ss.replacingOccurrences(of: ".", with: "")

        if let g = Int(ss) {
            if g > 800 && g < 1775 {
                return g
            }
        }
        return -1
    }
    
    private func findRecipe() -> Recipe {
        for r in recipies {
            if r.name == selectedRecipe {
                return r
            }
        }
        return recipies[0]
    }
    
    private func findBrewType() -> BrewType {
        for bt in brewTypes {
            if bt.typeDescription == selectedBrewType {
                return bt
            }
        }
        return brewTypes[0]
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

//struct AddBrewView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddBrewView()
//    }
//}
