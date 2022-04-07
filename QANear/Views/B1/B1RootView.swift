//
//  B1RoootView.swift
//  QANear
//
//  Created by zzr on 2021/10/22.
//

import SwiftUI

struct B1RootView: View {
    var body: some View {
        NavigationView{
            B1View().navigationBarTitle("B1")
        }
    }
}

struct B1RootView_Previews: PreviewProvider {
    static var previews: some View {
        B1RootView()
    }
}
