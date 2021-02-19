//
//  ViewModel.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-18.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var isPresentingImagePicker = false
    private(set) var sourceType: ImagePicker.SourceType = .camera
    
    func choosePhoto() {
        sourceType = .photoLibrary
        isPresentingImagePicker = true
    }
    
    func takePhoto() {
        sourceType = .camera
        isPresentingImagePicker = true
    }
    
    func didSelectImage(_ image: UIImage?) {
        if let img = image {
            selectedImage = img
        }
        isPresentingImagePicker = false
    }
}
