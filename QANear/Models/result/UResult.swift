//
//  Result.swift
//  QANear
//
//  Created by zzr on 2021/10/24.
//
import Foundation

struct UResult<T: Codable>: Codable {
    var code: Int
    var data: T?
    var msg: String
}
