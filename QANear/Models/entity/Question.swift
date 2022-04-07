//
//  Question.swift
//  QANear
//
//  Created by zzr on 2021/7/8.
//

import Foundation

struct Question: Codable,Identifiable {
    var id: Int
    var imgs: String
    var cotent: String
    var userId: Int
    var lastTime: String

    
}
