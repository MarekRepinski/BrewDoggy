//
//  GradeStarsNB.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-03-02.
//

import SwiftUI

struct GradeStarsNB: View {
    var grade: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: grade > 0 ? "star.fill" : "star")
                .foregroundColor(grade > 0  ? Color.yellow : Color.gray)

            Image(systemName: grade > 1 ? "star.fill" : "star")
                .foregroundColor(grade > 1  ? Color.yellow : Color.gray)

            Image(systemName: grade > 2 ? "star.fill" : "star")
                .foregroundColor(grade > 2  ? Color.yellow : Color.gray)

            Image(systemName: grade > 3 ? "star.fill" : "star")
                .foregroundColor(grade > 3  ? Color.yellow : Color.gray)

            Image(systemName: grade > 4 ? "star.fill" : "star")
                .foregroundColor(grade > 4  ? Color.yellow : Color.gray)

        }
    }
}

//struct GradeStarsNB_Previews: PreviewProvider {
//    static var previews: some View {
//        GradeStarsNB()
//    }
//}
