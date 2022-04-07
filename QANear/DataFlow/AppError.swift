//
//  AppError.swift
//  QANear
//
//  Created by zzr on 2021/10/22.
//

import Foundation

enum AppError: Error, Identifiable {
    var id: String {localizedDescription}
    
    case passwordWrong
    case networkingFailed(Error)
    case errorStr(String)
}

extension AppError : LocalizedError {
    var localizedDescription: String {
        switch self {
        case .passwordWrong: return "密码错误"
        case .networkingFailed(let error) : return error.localizedDescription
        case .errorStr(let str) : return str
        }
    }
}
