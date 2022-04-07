//
//  TryListView2View.swift
//  QANear
//
//  Created by zzr on 2021/7/7.
//

import SwiftUI
import FancyScrollView

struct TryListView2View: View {
    @State var numbers:[Int] = [23,45,76,54,76,3465,24,423,888,999,111,222,333,444,555,666,123,321,1234,4321,543,345,456,654,678,6789,9876,23456,6789,7890,9876,45678]
    
    var body: some View {
        FancyScrollView(title: "The Weeknd",
                        headerHeight: 350,
                        scrollUpHeaderBehavior: .parallax,
                        scrollDownHeaderBehavior: .sticky,
                        header: { Image("turtlerock").resizable() })
        {
            VStack {
                ForEach(self.numbers, id: \.self){ number in
                    VStack(alignment: .leading){
                        Text("\(number)")
                        Divider()
                    }
                }
            }
        }
    }
}

struct TryListView2View_Previews: PreviewProvider {
    static var previews: some View {
        TryListView2View()
    }
}
