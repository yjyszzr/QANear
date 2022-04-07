//
//  RegisterRequest.swift
//  QANear
//
//  Created by zzr on 2021/10/27.
//

import Foundation
import Combine
import Alamofire

struct RegisterRequest{
        let mobile: String
        let password: String
        let verifyPass: String

        var publisher : AnyPublisher<LoginSucUser, AppError> {
            Future { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() ) {
                    let device = Device(mac: "", plat: "iphone", channel: "c11111", lon: "", os: "14.5", w: 414, h: 736, appCodeName: "11", build: "14.5", apiv: "1", IDFA: "0CBC9945-8040-4746-A6A3-287DB3C548DA", appv: "0.0.1", appid: "467D8F6F-CBD1-4B6B-8285-291CD3F822C4", lat: "", province: "", city: "", brand: "Apple", net: "wifi", mid: "iPhone10,2");
                    let headers: HTTPHeaders = [
                        "token": "",
                        "Accept": "application/json"]
                    let addUBody = AddUBody(mobile: self.mobile, passWord: self.password, verifyPass: self.verifyPass, smsCode: "1234", loginSource: "2", pushKey: "")
                    let sign = ""
                    let be = Body(device: device, sign: sign, body: addUBody)

                    AF.request("http://139.198.14.224:9502/api/member/user/addU", method: .post, parameters: be, encoder: JSONParameterEncoder.default,headers:headers).responseDecodable(of: UResult<LoginSucUser>.self){ response in
                    DispatchQueue.main.async {
                        let code = try! response.result.get().code
                        
                        let msg = try! response.result.get().msg
                        if(code == 0){
                            let loginSucUser = try! response.result.get().data
                            //guard let lsu = loginSucUser else {return promise(.failure(.passwordWrong))}
                            promise(.success(loginSucUser!))
                        }else{
                            promise(.failure(.errorStr(msg)))
                        }
                    }
                }
                    
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        }
        
}
