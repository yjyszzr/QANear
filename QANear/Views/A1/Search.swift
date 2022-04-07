//
//  Search.swift
//  QANear
//
//  Created by zzr on 2021/7/2.
//
import SwiftUI

struct Search: View {
    @State private var showFavoritesOnly = false
    @State var isEditing: Bool = false
    @State var searchText: String = ""
    
    var body: some View {
        HStack {
            CircleImage(image: Image("turtlerock"))
                
            SearchBar(searchKey: .constant(""))
                .padding(.horizontal,2)
      
            NavigationLink(destination: AddQuestion()) {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.purple)
            }
        }
        .padding(.horizontal,2)
    }
    
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
