//
//  D1RootView.swift
//  QANear
//
//  Created by zzr on 2021/10/22.
//

import SwiftUI

struct D1RootView: View {
    var body: some View {
        NavigationView{
            D1View().navigationBarTitle("私人")
        }
    }
}

struct D1RootView_Previews: PreviewProvider {
    static var previews: some View {
        D1RootView()
    }
}
