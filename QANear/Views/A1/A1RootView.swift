//
//  A1RootView.swift
//  QANear
//
//  Created by zzr on 2021/10/22.
//
import SwiftUI
import Combine

struct A1RootView: View {
    
    @EnvironmentObject var store: Store
    
    var questionList: AppState.QuestionList { store.appState.questionList }
    
    var body: some View {
        NavigationView {
            if questionList.questions == nil {
                Text("Loading...").onAppear {
                    self.store.dispatch(.loadHotPageData(searchKey: ""))
                }
            } else {
                HomeView().navigationBarTitle("热页")
            }
        }
    }
}

struct A1RootView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        A1RootView().environmentObject(store)
    }
}
