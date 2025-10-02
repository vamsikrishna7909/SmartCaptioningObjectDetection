//
//  ImagePicker.swift
//  SmartCaptioningObjectDetection
//
//  Created by Vamsi Krishna Sivakavi on 9/8/25.
//

import Foundation
import SwiftUI
import UIKit

//Wrapping(Bridging the UIKit and SwiftUI) the UIImagePickerController to handle the camera
//UIViewControllerRepresentable protocol to wrap a UIKit view controller and expose it as a SwiftUI View
struct ImagePicker: UIViewControllerRepresentable {
    // Explicitly declare the associated types to satisfy the protocol
    typealias UIViewControllerType = UIImagePickerController
    //typealias Coordinator = ImagePickerCoordinator
    
    //sourceType tells UIKit whether we want .camera or .photoLibrary
    var sourceType: UIImagePickerController.SourceType
    
    @Binding var selectedImage: UIImage?
    
    //Connecting Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
    //Life cycle methods
    
    //Creates UIKit picker(UIImagePickerController) sets its delegates so we can know when the user picks or cancels
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    //Let's you update the controller if SwiftUI state changes
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    //UIKit communicates back via delegate callbacks.
    //SwiftUI doesn’t use delegates, so we create a Coordinator to act as the delegate and forward results back to SwiftUI.
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        //Called when the user selects a photo → assigns it to parent.selectedImage.
        //Dismisses the picker.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                // Normalize orientation
                let normalized = image.normalizedOrientation()
                // Optional: Resize if needed for model
                // let resized = normalized.resized(to: CGSize(width: 416, height: 416))
                parent.selectedImage = normalized
            }
            picker.dismiss(animated: true)
        }
        
        //Dismisses the picker.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

extension UIImage {
    func normalizedOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        if #available(iOS 17.0, *) {
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { image in
                draw(in: CGRect(origin: .zero, size: size))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
            self.draw(in: CGRect(origin: .zero, size: self.size))
            let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return normalizedImage ?? self
        }
    }
}
