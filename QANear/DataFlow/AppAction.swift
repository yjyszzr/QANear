//
//  AppAction.swift
//  QANear
//
//  Created by zzr on 2021/10/22.
//

import Foundation
import SwiftUI

enum AppAction {
    case loadHotPageData(searchKey: String)
    case loadHotPageDataDone(result: Result<[Question],AppError>)
    
    case login(mobile: String, password: String)
    case register(mobile: String, password: String,verifyPass: String)
    case accountBehaviorDone(result: Result<LoginSucUser, AppError>)
    case logout
    case emailValid(valid: Bool)
    case clearCache
    case closeSafariView
    case saveQuestion(comnet: String,imgArr: String,uploaddata: [UIImage?]?)
    case questionDetail(id: String)
    case loadQdDone(result: Result<Question,AppError>)
}
