//
//  CemeraView.swift
//  QANear
//
//  Created by zzr on 2021/11/28.
//
import SwiftUI
import UIKit
import Gallery
import Lightbox
import AVFoundation
import AVKit
import SVProgressHUD

struct CameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var cimages: [UIImage?]?
    
    class Coordinator: NSObject,LightboxControllerDismissalDelegate, GalleryControllerDelegate {
        
        var gallery: GalleryController!
        
        var parent: CameraView
        
        var ssimages: [UIImage?]?
        
        let editor: VideoEditing = VideoEditor()

        init(_ parent: CameraView) {
            self.parent = parent
        }
         
        func galleryController(_ controller: GalleryController, didSelectImages images: [Gallery.Image]) {
            Gallery.Image.resolve(images: images, completion: {
                (s) -> Void in
                self.parent.cimages = s
            })
            controller.dismiss(animated: true, completion: nil)
            gallery = nil
        }
        
        func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
            controller.dismiss(animated: true, completion: nil)
            gallery = nil

            editor.edit(video: video) { (editedVideo: Video?, tempPath: URL?) in
              DispatchQueue.main.async {
                if let tempPath = tempPath {
                  let controller = AVPlayerViewController()
                  controller.player = AVPlayer(url: tempPath)

                  //self.present(controller, animated: true, completion: nil)
                }
              }
            }
        }
        
        func galleryController(_ controller: GalleryController, requestLightbox images: [Gallery.Image]) {
        
        }
        
        func lightboxControllerWillDismiss(_ controller: LightboxController) {

        }
        
        func galleryControllerDidCancel(_ controller: GalleryController) {
            controller.dismiss(animated: true, completion: nil)
            gallery = nil
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> GalleryController {
        let picker = GalleryController()
        picker.delegate = context.coordinator
        return picker
    }
    
    // Tbh no idea what to do here
    func updateUIViewController(_ uiViewController: GalleryController, context: UIViewControllerRepresentableContext<CameraView>) {

    }
}
