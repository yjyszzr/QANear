//
//  LoginRequest.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/07.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation
import Combine
import Alamofire
import SwiftUI


struct LoginRequest {
//    let email: String
    let mobile: String
    let password: String

    var publisher : AnyPublisher<LoginSucUser, AppError> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() ) {
                let device = Device(mac: "", plat: "iphone", channel: "c11111", lon: "", os: "14.5", w: 414, h: 736, appCodeName: "11", build: "14.5", apiv: "1", IDFA: "0CBC9945-8040-4746-A6A3-287DB3C548DA", appv: "0.0.1", appid: "467D8F6F-CBD1-4B6B-8285-291CD3F822C4", lat: "", province: "", city: "", brand: "Apple", net: "wifi", mid: "iPhone10,2");
                let headers: HTTPHeaders = [
                    "token": "",
                    "Accept": "application/json"]
                let loginBody = LoginBody(mobile:self.mobile,password:self.password,loginSource:"2",pushKey:"")
                let sign = ""
                let be = Body(device: device, sign: sign, body: loginBody)

                AF.request("http://139.198.14.224:9502/api/member/login/loginByPass", method: .post, parameters: be, encoder: JSONParameterEncoder.default,headers:headers).responseDecodable(of: UResult<LoginSucUser>.self){ response in
                DispatchQueue.main.async {
                    let code = try? response.result.get().code
                    let msg = try? response.result.get().msg
                    if(code == 0){
                        let loginSucUser = try! response.result.get().data
                        //guard let lsu = loginSucUser else {return promise(.failure(.passwordWrong))}
                        promise(.success(loginSucUser!))
                    }else{
                        promise(.failure(.errorStr(msg ?? "")))
                    }
                }
            }
                
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    

    
}


