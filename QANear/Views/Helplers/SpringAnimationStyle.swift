//
//  SpringAnimationStyle.swift
//  QANear
//
//  Created by zzr on 2021/11/4.
//
import SwiftUI

struct SpringAnimationStyle: ViewModifier {
  @Binding var isAnimating: Bool
  var delay = 0.0
  
  func body(content: Content) -> some View {
    content
      .opacity(isAnimating ? 1 : 0)
      .animation(Animation.spring().delay(delay))
  }
}

