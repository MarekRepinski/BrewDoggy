//
//  AddBrewCheckView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-28.
//

import SwiftUI

struct AddBrewCheckView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var gravity = ""
    @State private var comment = ""
    @State private var changed = false
    @State private var showChangeAlert = false
    @State private var showGravityAlert = false
    var brew: Brew
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Make a new Brew Check")
                    .font(.title)
                    .bold()
                    .padding()
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Gravity:")
                            .bold()
                        TextField("Gravity", text: $gravity)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: gravity) {dummy in
                                changed = true
                            }
                    }
                    .padding(.horizontal, 10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    
                    VStack {
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
                              primaryButton: .default(Text("Yes")) { saveBrewCheck() },
                              secondaryButton: .cancel(Text("No")) { self.presentationMode.wrappedValue.dismiss() })
                    }

                    Spacer()

                    HStack {
                        Spacer()
                        Button(action: { saveBrewCheck() }) {
                            Text("Save")
                                .font(.title)
                                .bold()
                        }
                        Spacer()
                    }
                    .padding()
                    .alert(isPresented: $showGravityAlert) {
                        Alert(title: Text("Unclear Gravity"),
                              message: Text("Please enter Gravity between 800 and 1775 or leave it empty"),
                              dismissButton: .cancel())
                    }
                }
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
    
    private func saveBrewCheck() {
        let g = checkGravity(s: gravity)
        if g > -1 {
            let newBrewCheck = BrewCheck(context: viewContext)
            newBrewCheck.id = UUID()
            newBrewCheck.date = Date()
            newBrewCheck.gravity = Int64(g)
            newBrewCheck.comment = comment
            newBrewCheck.timestamp = Date()
            newBrewCheck.brewCheckToBrew = brew
            saveViewContext()
            self.presentationMode.wrappedValue.dismiss()
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
    
    private func saveViewContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

//struct AddBrewCheckView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddBrewCheckView()
//    }
//}
