//
//  TryListView.swift
//  QANear
//
//  Created by zzr on 2021/7/6.
//

import SwiftUI
import AdvancedList
 

struct TryListView: View {
    @State private var listState: ListState = .items
    @State var numbers:[Int] = [23,45,76,54,76,3465,24,423,888,999,111,222,333,444,555,666,123,321,1234,4321,543,345,456,654,678,6789,9876,23456,6789,7890,9876,45678]
    
    var body: some View {
        AdvancedList(numbers, content: { item in
            Text("\(item)")
        }, listState: listState, emptyStateView: {
            Text("No data")
        }, errorStateView: { error in
            Text(error.localizedDescription)
                .lineLimit(nil)
        }, loadingStateView: {
            Text("Loading ...")
        })
        .onMove { (indexSet, index) in
            // move me
        }
        .onDelete { indexSet in
            // delete me
        }
        
    }
}

extension Int: Identifiable {
    public typealias ID = Int
    public var id: ID {
        return self
    }
}


struct TryListView_Previews: PreviewProvider {
    static var previews: some View {
        TryListView()
    }
}
