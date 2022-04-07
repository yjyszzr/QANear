//
//  CircleImage.swift
//  QANear
//
//  Created by zzr on 2021/7/2.
//


import SwiftUI

struct CircleImage: View {
    var image: Image

    var body: some View {
      VStack {
        image.resizable()
              .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
              .overlay(Circle().stroke(Color.white, lineWidth: 2))
              .shadow(radius: 3)
      }.frame(width: 37, height: 37, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }

}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("turtlerock"))
    }
}
