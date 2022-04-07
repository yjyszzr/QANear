//
//  AddQuestion.swift
//  QANear
//
//  Created by zzr on 2021/11/4.
//
import Foundation
import SwiftUI
import UIKit
import Gallery
import ZLPhotoBrowser
import Photos

struct AddQuestion: View {
    var collectionView: UICollectionView!
    
    var selectedImages: [UIImage] = []
    
    var selectedAssets: [PHAsset] = []
    
    var isOriginal = false
    
    var takeSelectedAssetsSwitch: UISwitch!
    
    
    @EnvironmentObject var store: Store
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var inputImage: [UIImage?]?
    @State private var showingImagePicker = false
    @State private var askComent = ""
    @State public var imgData: [Data]?
    @State private var image: SwiftUI.Image?
    var settingsBinding: Binding<AppState.Settings> {
        $store.appState.settings
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                SubPageTopTitle(title: "ask", subTitle: "info")

                Button(action:{
                    self.presentationMode.wrappedValue.dismiss()
                    self.store.dispatch(.saveQuestion(comnet: askComent, imgArr: "/c1Y",uploaddata: inputImage))
                }){
                    Text("保存")
                }.alert(isPresented: settingsBinding.showAddQuestionAlert) {
                    Alert(title: Text("问题已经提交，等待别人回答"), message: Text(""), dismissButton: .default(Text("Got it!")))
                }
            }
          
            GeometryReader { gro in
                ScrollView {
                    TextEditor(text:$askComent)
                        .frame(width: gro.size.width, height: 300, alignment:.center)
                    
                    Button("+pic") {
                       self.showingImagePicker = true
                    }

                    //image?.resizable().scaledToFit()
                    
                    VStack(spacing: 12) {
                        if(inputImage != nil){
                            imageView
                        }
                    }
                }
            }

        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            CameraView(cimages: self.$inputImage)
            //CameraLibrary()
        }
        .modifier(SubPageContainer())
    }
    
  
    
    
    var imageView: some View {
        VStack {
            ForEach(inputImage ?? [], id: \.self) { image in
                DraggableImage(image: image!)
            }
        }
    }
     
    func loadImage() {
        guard let sinputImage = inputImage else { return }
        print("sinputImage num:\(sinputImage.count)")
    }
    
}

struct AddQuestion_Previews: PreviewProvider {
    static var previews: some View {
        AddQuestion().environmentObject(Store())
    }
}
