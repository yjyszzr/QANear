//
//  CemeraView.swift
//  QANear
//
//  Created by zzr on 2021/11/28.
//
import Foundation
import UIKit
import SwiftUI
import ZLPhotoBrowser
import Photos

struct CameraLibrary: UIViewControllerRepresentable {
//    class Coordinator: NSObject {
//        var parent: CameraLibrary
//
//        init(_ parent: CameraLibrary) {
//            self.parent = parent
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraLibrary>) -> WeChatMomentDemoViewController {
        let picker = WeChatMomentDemoViewController()
        return picker
    }
         
    func updateUIViewController(_ uiViewController: WeChatMomentDemoViewController, context: Context) {
        //uiViewController.viewDidLoad()
    }
     
}
