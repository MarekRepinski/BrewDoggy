//
//  GradeStars.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-03-01.
//

import SwiftUI

// Make five stars for rating, with binding
struct GradeStars: View {
    @Binding var grade: Int
    var setGrade: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: grade > 0 ? "star.fill" : "star")
                .foregroundColor(grade > 0  ? Color.yellow : Color.gray)
                .onTapGesture {
                    if setGrade {
                        grade = 1
                    }
                }
            Image(systemName: grade > 1 ? "star.fill" : "star")
                .foregroundColor(grade > 1  ? Color.yellow : Color.gray)
                .onTapGesture {
                    if setGrade {
                        grade = 2
                    }
                }
            Image(systemName: grade > 2 ? "star.fill" : "star")
                .foregroundColor(grade > 2  ? Color.yellow : Color.gray)
                .onTapGesture {
                    if setGrade {
                        grade = 3
                    }
                }
            Image(systemName: grade > 3 ? "star.fill" : "star")
                .foregroundColor(grade > 3  ? Color.yellow : Color.gray)
                .onTapGesture {
                    if setGrade {
                        grade = 4
                    }
                }
            Image(systemName: grade > 4 ? "star.fill" : "star")
                .foregroundColor(grade > 4  ? Color.yellow : Color.gray)
                .onTapGesture {
                    if setGrade {
                        grade = 5
                    }
                }
        }
    }
}

//struct GradeStars_Previews: PreviewProvider {
//    static var previews: some View {
//        GradeStars()
//    }
//}
