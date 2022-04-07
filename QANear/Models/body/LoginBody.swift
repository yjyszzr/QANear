//
//  LoginBody.swift
//  QANear
//
//  Created by zzr on 2021/10/24.
//

import Foundation
import UIKit

class LoginBody: Codable {
    var mobile: String
    var password: String
    var loginSource: String
    var pushKey: String
    
    init(mobile: String,password: String,loginSource: String,pushKey: String) {
        self.mobile = mobile
        self.password = password
        self.loginSource = loginSource
        self.pushKey = pushKey
    }
}
