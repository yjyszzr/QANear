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

struct LoadQuestionRequest {
    let id: String

    var publisher : AnyPublisher<Question, AppError> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() ) {
                let device = Device(mac: "", plat: "iphone", channel: "c11111", lon: "", os: "14.5", w: 414, h: 736, appCodeName: "11", build: "14.5", apiv: "1", IDFA: "0CBC9945-8040-4746-A6A3-287DB3C548DA", appv: "0.0.1", appid: "467D8F6F-CBD1-4B6B-8285-291CD3F822C4", lat: "", province: "", city: "", brand: "Apple", net: "wifi", mid: "iPhone10,2");
                let headers: HTTPHeaders = [
                    "token": "",
                    "Accept": "application/json"]
                let idBody = IdBody(id: id)
                let sign = ""
                let be = Body(device: device, sign: sign, body: idBody)
                AF.request("http://139.198.14.224:9502/api/order/order/qd", method: .post, parameters: be, encoder: JSONParameterEncoder.default,headers:headers).responseDecodable(of: UResult<Question>.self){ response in
                DispatchQueue.main.async {
                    let code = try? response.result.get().code
                    let msg = try? response.result.get().msg
                    if(code == 0){
                        let qd = try! response.result.get().data
                        promise(.success(qd!))
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


