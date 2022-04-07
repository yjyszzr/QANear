//
//  CL.swift
//  QANear
//
//  Created by zzr on 2021/11/5.
//

import Foundation
import UIKit

class CL:UIViewController {
    
}

extension UIViewController :UIImagePickerControllerDelegate, UINavigationControllerDelegate, PropertyStoring {
    
    public typealias T = String
    public typealias AlbumT = Int
    private struct CustomProperties {
        static var imgType = UIImagePickerController.InfoKey.originalImage
        static var isAlbum = UIImagePickerController.SourceType.photoLibrary
    }
    
    var imgType: String {
        get {
            return getAssociatedObject(&CustomProperties.imgType, defaultValue: CustomProperties.imgType.rawValue)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.imgType, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var albumType: Int {
        get {
            return getAssociatedObject(&CustomProperties.isAlbum, defaultValue: CustomProperties.isAlbum.rawValue)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.isAlbum, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func invokingSystemAlbumOrCamera(type: String, albumT: Int) -> Void {
        
        self.imgType = type
        self.albumType = albumT
        if albumT == UIImagePickerController.SourceType.photoLibrary.rawValue {
            self.invokeSystemPhoto()
        }else {
            self.invokeSystemCamera()
        }
    }
    
    func invokeSystemPhoto() -> Void {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = false
            if self.imgType == UIImagePickerController.InfoKey.originalImage.rawValue {
                imagePickerController.allowsEditing = true
            }else {
                imagePickerController.allowsEditing = false
            }
            if #available(iOS 11.0, *) {
                UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
            }
             
            self.present(imagePickerController, animated: true, completion: nil)
        }else {
            print("请打开允许访问相册权限")
        }
    }
    
    func invokeSystemCamera() -> Void {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = false
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.mediaTypes = ["public.image"]
            self.imgType = UIImagePickerController.InfoKey.originalImage.rawValue
            if #available(iOS 11.0, *) {
                UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
            }
            self.present(imagePickerController, animated: true, completion: nil)
        }else {
            print("请打开允许访问相机权限")
        }
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        picker.dismiss(animated: true, completion: nil)
        let img = info[self.imgType] as! UIImage
        if self.albumType == UIImagePickerController.SourceType.photoLibrary.rawValue {
            self.reloadViewWithImg(img: img)
        }else {
            self.reloadViewWithCameraImg(img: img)
        }
    }
    
    @objc func reloadViewWithImg(img: UIImage) -> Void {
        
    }
    
    @objc func reloadViewWithCameraImg(img: UIImage) -> Void {
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        self.dismiss(animated: true, completion: nil)
    }
}

