//
//  ImagePicker.swift
//  QANear
//
//  Created by zzr on 2021/11/5.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
       @Environment(\.presentationMode) var presentationMode
       @Binding var image: UIImage?

       class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
           var parent: ImagePicker

           init(_ parent: ImagePicker) {
               self.parent = parent
           }
           
           func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
               if let uiImage = info[.originalImage] as? UIImage {
                   parent.image = uiImage
               }

               parent.presentationMode.wrappedValue.dismiss()
           }
       }

       func makeCoordinator() -> Coordinator {
           Coordinator(self)
       }

       func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
           let picker = UIImagePickerController()
           picker.delegate = context.coordinator
           return picker
       }

       func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

       }
    

}
