//
//  AddTasteView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-03-02.
//

import SwiftUI

struct AddTasteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var bottles = 1
    @State private var comment = ""
    @State private var rate = 0
    @State private var changed = false
    @State private var showChangeAlert = false
    @State private var showBottlesPicker = false
    var store: WineCellar
    var maxNoOfBottles: Int
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Take a new Taste")
                    .font(.title)
                    .bold()
                    .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Number of tasted bottles:")
                            .bold()

                        Spacer()

                        Button(action: { self.showBottlesPicker.toggle() }){
                            Text("\(bottles)")

                        }

                        Spacer()
                    }
                    .padding(10)
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
                }
                
                HStack() {
                    Text("Rate tasting:")
                        .bold()
                    Spacer()
                    GradeStars(grade: $rate, setGrade: true)
                    Spacer()
                }
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                
                VStack(alignment: .center, spacing: 10) {
                    Text("Comment:")
                        .bold()
                    TextEditor(text: $comment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 200)
                        .onChange(of: comment) {dummy in
                            changed = true
                        }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .alert(isPresented: $showChangeAlert) {
                    Alert(title: Text("Forgot to save?"),
                          message: Text("Do you want to save before exit?"),
                          primaryButton: .default(Text("Yes")) { saveTaste() },
                          secondaryButton: .cancel(Text("No")) { self.presentationMode.wrappedValue.dismiss() })
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: { saveTaste() }) {
                        Text("Save")
                            .font(.title)
                            .bold()
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                                    Button(action: {
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
                                    })
        }
    }
    
    private func saveTaste() {
        let newTaste = Taste(context: viewContext)
        newTaste.id = UUID()
        newTaste.date = Date()
        newTaste.bottles = Int64(bottles)
        newTaste.rate = Int64(rate)
        newTaste.comment = comment
        newTaste.timestamp = Date()
        newTaste.tasteToWineCellar = store
        saveViewContext()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func checkBottles(s: String) -> Int {
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
    
    private func saveViewContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
//struct AddTasteView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTasteView()
//    }
//}
