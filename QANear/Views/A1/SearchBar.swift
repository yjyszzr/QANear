//
//  SearchBar.swift
//  ToDoList
//
//  Created by Simon Ng on 15/4/2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchKey: String
    @State private var isEditing = false
    @FocusState private var amountIsFocused: Bool
    @EnvironmentObject var store: Store
        
    var body: some View {
        HStack {
            
            TextField("Search ...", text: $searchKey)
                .padding(7)
                .padding(.leading, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading,8)
                        
                        if isEditing {
                            Button(action: {
                                self.searchKey = ""
                                
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 1)
                            }
                        }
                    }
                )
                .focused($amountIsFocused)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()

                        Button("Done") {
                            amountIsFocused = false
                        }
                    }
                }
                .onTapGesture {
                    self.isEditing = true
                }
            
            Button(action:{
                self.store.dispatch(.loadHotPageData(searchKey: searchKey))
            }){
                Text("搜索")
            }
//            if isEditing {
//                Button(action: {
//                    self.isEditing = false
//                    self.searchKey = ""
//
//                    // Dismiss the keyboard 取消键盘
//                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                }) {
//
//                }
//                .padding(.trailing, 10)
//                .transition(.move(edge: .trailing))
//                .animation(.default)
//            }
            
            

        }
    }
}

//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar(searchKey: .constant(""), text: .constant(""))
//    }
//}
