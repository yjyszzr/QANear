
//
//  SubPageTopTitle.swift
//  SwiftUI-Project
//
//  Created by huanbing on 2020/2/3.
//  Copyright © 2020 unrealce. All rights reserved.
//

import SwiftUI
import UIKit
import Foundation

struct SubPageTopTitle: View {
    

  var title: String
  var subTitle: String
  var withArrow = true
  
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State private var isAnimating = false
  
  var body: some View {
    HStack(alignment: .top) {
      if withArrow {
        Image(systemName: "arrow.left")
          .font(.system(size: 20))
          .offset(x: 0, y: 8)
          .padding(.trailing, 5)
          .modifier(SpringAnimationStyle(isAnimating: $isAnimating))
          .onTapGesture {
            self.presentationMode.wrappedValue.dismiss()
          }
      }
      VStack(alignment: .leading, spacing: 0) {
        Text("主标题")
          .modifier(BigTitle())
          .padding(.bottom, 5)
          .modifier(SpringAnimationStyle(isAnimating: $isAnimating, delay: 0.1))
        Text("副标题")
          .fontWeight(.light)
          .modifier(SubTitle())
          .modifier(SpringAnimationStyle(isAnimating: $isAnimating, delay: 0.2))
      }
      Spacer()

    }.frame(width: 320)
    .onAppear() {
      self.isAnimating = true
    }
  }
    
//    func Test(){
//        NSInputStream *inputStream = nil; // file input stream
//        NSString *sourceId = @""; // source 作为断点续传的标识，保证每个文件不同
//        long long size = -1; // input stream 大小，不知道时为 -1，size 对progress 进度有影响
//        NSString *key = @""; // 存储的key
//        NSString *token = @""; // 七牛token
//        [upManager putInputStream:inputStream sourceId:sourceId size:size fileName:key key:key token:token complete:^(QNResponseInfo *info, NSString *k, NSDictionary *resp) {
//                            
//        } option:option];
//
//    }
}

struct SubPageTopTitle_Previews: PreviewProvider {
    static var previews: some View {
        SubPageTopTitle(title: "主标题", subTitle: "副标题").environmentObject(Store())
    }
}
