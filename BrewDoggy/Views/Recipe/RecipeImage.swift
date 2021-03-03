//
//  RecipeImage.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-08.
//

import SwiftUI

// Display image, used not only in recipe segment
struct RecipeImage: View {
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 15)
            .frame(width: 350, height: 200, alignment: .center)
    }
}

//struct RecipeImage_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeImage(image: Image("beerStandard"))
//    }
//}

