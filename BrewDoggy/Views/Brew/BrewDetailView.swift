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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BrewCheck.date, ascending: false)], animation: .default)
    private var brewChecks: FetchedResults<BrewCheck>
    
    @State private var currentItems: [ItemRow] = []
    @State private var types: [String] = []
    @State private var bruteForceReload = false
    @State private var editIsActive = false
    @State private var isDone = false
    @State private var daysLeft = 0
    @Binding var isAddActive: Bool
    
    var brew: Brew
    
    var brewIndex: Int {
        brews.firstIndex(where: { $0.id == brew.id})!
    }
    
    var filteredBrewItems: [BrewCheck] {
        brewChecks.filter { bc in
            (bc.brewCheckToBrew == brew)
        }
    }
    
    var body: some View {
        ScrollView {
//            NavigationLink(destination: EditRecipeView(isSet: $bruteForceReload, recipe: recipe),
//                           isActive: $editIsActive) { EmptyView() }.hidden()

            RecipeImage(image: UIImage(data: brew.picture!)!)
                .padding(.top, 20)

            HStack {
                VStack(alignment: .leading) {
                    Text("\(brew.name!)")
                        .font(.title2)
                }
                Spacer()
                if isDone {
                    GradeStarsView(full: Int(brew.grade), empty: 5 - Int(brew.grade))
                } else {
                    if daysLeft < 0 {
                        Text("Past Due date!!")
                            .foregroundColor(.red)
                    } else {
                        Text("\(daysLeft) days left")
                            .foregroundColor(.green)
                    }
                }
                
            }
            .padding(.horizontal, 15)

            Divider()
        }
        .onAppear() {
            isDone = brew.isDone
            daysLeft = daysBetween(start: Date(), end: brew.eta!)
        }
    }

    private func daysBetween(start: Date, end: Date) -> Int {
       Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
}

struct GradeStarsView: View {
    var full: Int
    var empty: Int

    var body: some View {
        ForEach(0..<full) {_ in
            Image(systemName: "star.fill")
                .imageScale(.large)
                .foregroundColor(.yellow)
        }
        ForEach(0..<empty) {_ in
            Image(systemName: "star")
                .imageScale(.large)
                .foregroundColor(.yellow)
        }
    }
}

//struct BrewDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BrewDetailView()
//    }
//}
