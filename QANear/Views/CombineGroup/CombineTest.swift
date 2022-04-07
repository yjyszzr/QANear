//
//  CombineTest.swift
//  QANear
//
//  Created by zzr on 2022/1/12.
//
import Foundation
extension Notification.Name{
    static var newTrickDownloaded:Notification.Name {
        return Notification.Name("aa")
    }
}

class MagicTrick:Codable {
    var name:String = ""
}

//let trickNamePublisher = NotificationCenter.Publisher(center: .default, name: .newTrickDownloaded)

let trickNamePublisher = NotificationCenter.Publisher(center: .default, name: .newTrickDownloaded)
    .map{ notification -> Data in
        let userInfo = notification.userInfo
        return userInfo?["data"] as! Data
    }
//    .tryMap { data -> MagicTrick in
//        let decoder = JSONDecoder()
//        return try decoder.decode(MagicTrick.self, from: data)
//    }
    .decode(type: MagicTrick.self, decoder: JSONDecoder())
