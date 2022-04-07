//
//  SceneDelegate.swift
//  animated-tabbar
//
//  Created by Arvind on 20/12/20.
//

import SwiftUI

struct ContentView : View {
    let tabList: [String] = ["home", "heart", "dumbbell", "camera"]
    @State private var selectedTabBar = "home"
    @State public var xOffSet: CGFloat = 0

    var body: some View {
        
        TabView(selection: $selectedTabBar) {
            A1RootView().tabItem {
                    Image(systemName: "star")
                    Text("热页")
                }
            B1RootView().tabItem {
                Image(systemName: "heart")
                Text("递进")
            }
            C1RootView().tabItem {
                Image(systemName: "staroflife")
                Text("辅助")
            }
            SettingView().tabItem {
                Image(systemName: "camera")
                Text("隐私")
            }
        }.edgesIgnoringSafeArea(.top)
        

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Store())
    }

}
