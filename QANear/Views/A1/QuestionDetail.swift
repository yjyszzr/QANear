////
////  QuestionDetail.swift
////  QANear
////
////  Created by zzr on 2022/1/10.
////
////
////  AddQuestion.swift
////  QANear
////
////  Created by zzr on 2021/11/4.
////
//import Foundation
//import SwiftUI
//import UIKit
//import Gallery
//import ZLPhotoBrowser
//import Photos
//
//struct QuestionDetail: View {
//    @EnvironmentObject var store: Store
//    var settings: AppState.Settings {
//        store.appState.settings
//    }
//    
//    var collectionView: UICollectionView!
//    
//    var selectedImages: [UIImage] = []
//    
//    var selectedAssets: [PHAsset] = []
//    
//    var isOriginal = false
//    
//    var takeSelectedAssetsSwitch: UISwitch!
//    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @State private var inputImage: [UIImage?]?
//    @State private var showingImagePicker = false
//    @State private var askComent = ""
//    @State public var imgData: [Data]?
//    @State private var image: SwiftUI.Image?
//    var settingsBinding: Binding<AppState.Settings> {
//        $store.appState.settings
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            HStack {
//                SubPageTopTitle(title: "ask", subTitle: "info")
//            }
//          
//            GeometryReader { gro in
//                ScrollView {
//                    //TextEditor("\(settings.qd?.cotent)")//settings.qd?.cotent
//                        //.frame(width: gro.size.width, height: 300, alignment:.center)
//                    
//                    Button("+pic") {
//                       self.showingImagePicker = true
//                    }
//                    
//                    VStack(spacing: 12) {
//                        if(inputImage != nil){
//                            imageView
//                        }
//                    }
//                }
//            }
//
//        }.onAppear(
//            perform:
//            {
//                var imageView: some View {
//                    VStack {
//                        ForEach(inputImage ?? [], id: \.self) { image in
//                            DraggableImage(image: image!)
//                        }
//                    }
//                }
//                
//            }
//        )
//        .modifier(SubPageContainer())
//    }
//     
//    func loadImage() {
//        guard let sinputImage = inputImage else { return }
//        print("sinputImage num:\(sinputImage.count)")
//    }
//}
//
//struct QuestionDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionDetail().environmentObject(Store())
//    }
//}
//
