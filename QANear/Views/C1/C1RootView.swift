//
//  C1RootView.swift
//  QANear
//
//  Created by zzr on 2021/10/22.
//

import SwiftUI

struct C1RootView: View {
    var body: some View {
        NavigationView{
            C1View().navigationBarTitle("C1")
        }
    }
}

struct C1RootView_Previews: PreviewProvider {
    static var previews: some View {
        C1RootView()
    }
}
