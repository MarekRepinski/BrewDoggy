//
//  CreateQR.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-03-03.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

// Create QR-Code and let user share it
struct CreateQR: View {
    @State private var items: [UIImage] = []
    @State private var sheet = false

    var id: UUID
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Image(uiImage:  generateQRCode(from: id.uuidString))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
            
            Spacer()
            
            Button(action: {
                //adding items to be shared...
                items.removeAll()
                items.append(generateQRCode(from: id.uuidString))
                
                sheet.toggle()
            }, label: {
                Text("Share")
                    .fontWeight(.heavy)
            })

            Spacer()
        }
        .sheet(isPresented: $sheet) {
            ShareSheet(items: items)
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [UIImage]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}



struct CreateQR_Previews: PreviewProvider {
    static var previews: some View {
        CreateQR(id: UUID())
    }
}
