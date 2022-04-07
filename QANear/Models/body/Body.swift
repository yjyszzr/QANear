//
//  Body.swift
//  QANear
//
//  Created by zzr on 2021/10/24.
//

import Foundation

struct Body<T: Codable>:Codable {
    var device: Device
    var sign: String
    var body: T?
    
    init(device: Device,sign: String,body: T) {
        self.device = device
        self.sign = sign
        self.body = body
    }
}

