//
//  ContentView.swift
//  QANear
//
//  Created by zzr on 2021/7/2.
//

import SwiftUI
import FancyScrollView
import Kingfisher
import CoreLocation

struct HomeView: View {
    @EnvironmentObject var store: Store
    var questionList : AppState.QuestionList {
        store.appState.questionList
    }

    @State private var showingSheet = false
    @ObservedObject var locationObserver = LocationObserver()
    private let contentSize = 20
    @State var page = 1
    
    var body: some View {
        FancyScrollView(title: "The Weeknd",
                        headerHeight: 350,
                        scrollUpHeaderBehavior: .parallax,
                        scrollDownHeaderBehavior: .sticky,
                        header:
                            {
                                LMapView(coordinate: self.locationObserver.location.coordinate)
                            }
        )
        {
                          VStack{
                            HStack{
                               Search()
                            }
                            VStack{
                               // List {
                                    ForEach(questionList.displayQuestions()   ){ question in
                                        VStack(alignment: .leading){
                                            HStack {
                                                Image(systemName: "moon.zzz")
                                                Text("\(question.userId)")

                                            }
                                            Spacer()
                                            HStack(alignment: .bottom) {
                                                Text("\(question.userId)")
                                                    .padding(.trailing,10)
                                                Spacer()
             
                                                Text("\(question.lastTime)")
                                                    .padding(.trailing,10)
                                                    
                                            }
                                            .padding(.trailing,10)
                                            Spacer()
                                            HStack{
                                                Text("\(question.cotent)")
                                                    .padding(.trailing,10)
                                                Spacer()
                                                KFImage.url(URL(string: question.imgs )!).resizable()
                                                    .fade(duration: 1)
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 35, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                                    .cornerRadius(8)
                                            }

                                            Divider()
                                        }
                                    }
                               // }
                            }.onAppear(
                                perform: {
                                    self.store.dispatch(.loadHotPageData(searchKey: ""))
                                }
                            )
                        }
                      .padding(3)
                      .padding(.horizontal,6)
                      .ignoresSafeArea()
        }.refreshable(action:
             { self.store.dispatch(.loadHotPageData(searchKey: "")) }
        )
//        .sheet(isPresented: $showingSheet) {
//            AddQuestion().environmentObject(store)
//        }
        
    }
    
    func loadMore() {
        if self.page < 4 {
            self.page += 1
            print("Load more..." + "\(page)")
        }
    }
    

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(Store())
            
    }
}
