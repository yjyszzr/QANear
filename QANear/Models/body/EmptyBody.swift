//
//  EmptyBody.swift
//  QANear
//
//  Created by zzr on 2021/11/3.
//
import Foundation

class EmptyBody: Codable {
    var emptyStr: String

    init(emptyStr: String) {
        self.emptyStr = emptyStr
    }
}
