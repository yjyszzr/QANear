//
//  TodoItemView.swift
//  ToDoCoreData
//
//  Created by BaronZhang.
//

import SwiftUI

struct TodoItemView: View {
    var mobile:String = ""
    var token:String = ""
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(mobile)
                    .font(.headline)
                Text(token)
                    .font(.caption)
            }
        }
    }
}

struct TodoItemView_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemView(mobile: "sss", token: "sss")
    }
}
