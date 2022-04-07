//
//  SearchKeyBody.swift
//  QANear
//
//  Created by zzr on 2021/11/26.
//

import Foundation

class SearchKeyBody: Codable {
    var searchKey: String

    init(searchKey: String) {
        self.searchKey = searchKey
    }
}
