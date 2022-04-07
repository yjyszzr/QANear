//
//  Device.swift
//  QANear
//
//  Created by zzr on 2021/10/24.
//

import Foundation

struct Device: Codable {
    var mac: String
    var plat: String
    var channel: String
    var lon: String
    var os: String
    var w: Int
    var h: Int
    var appCodeName: String
    var build: String
    var apiv: String
    var IDFA: String
    var appv: String
    var appid: String
    var lat: String
    var province: String
    var city: String
    var brand: String
    var net: String
    var mid: String
}
