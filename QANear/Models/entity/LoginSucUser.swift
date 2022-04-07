//
//  LoginSucUser.swift
//  QANear
//
//  Created by zzr on 2021/10/24.
//
import Foundation

struct LoginSucUser: Codable{
    var token: String
    var mobile: String
    var userName: String
    var nickName: String
    var headImg: String
    var isReal: String
    var userType: String
}
