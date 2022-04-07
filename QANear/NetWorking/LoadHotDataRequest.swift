//
//  LoadHotDataRequest.swift
//  QANear
//
//  Created by zzr on 2021/10/22.
//
import Foundation
import Alamofire
import Combine
import SwiftUI

struct LoadHotDataRequest {
    let searchKey: String
    
//    static var hotdata: AnyPublisher<[Question], AppError> {
//        hotDataPublisher()
//            .mapError { AppError.networkingFailed($0) }
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
    
    var publisher : AnyPublisher<[Question], AppError> {
        Future { promise in
                let device = Device(mac: "", plat: "iphone", channel: "c11111", lon: "", os: "14.5", w: 414, h: 736, appCodeName: "11", build: "14.5", apiv: "1", IDFA: "0CBC9945-8040-4746-A6A3-287DB3C548DA", appv: "0.0.1", appid: "467D8F6F-CBD1-4B6B-8285-291CD3F822C4", lat: "", province: "", city: "", brand: "Apple", net: "wifi", mid: "iPhone10,2");
                let token = getToken()

                let headers: HTTPHeaders = [
                    "token": token,
                    "Accept": "application/json"]
            let searchKeyBody = SearchKeyBody(searchKey: searchKey)
                let sign = ""
                let be = Body(device: device, sign: sign, body: searchKeyBody)
    
            AF.request("http://139.198.14.224:9502/api/order/order/quetions", method: .post, parameters: be, encoder: JSONParameterEncoder.default,headers:headers).responseDecodable(of: UResult<[Question]>.self){ response in
//                    DispatchQueue.main.async {
                        let code = try? response.result.get().code
                        let msg = try? response.result.get().msg
                        if(code == 0){
                            let questions = try! response.result.get().data
                            promise(.success(questions!))
                        }else{
                            promise(.failure(.errorStr(msg ?? "20211125wrong")))
                        }
//                    }
                }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
              
    public func getToken() -> String {
        var token = ""
        let request = LU.sortedFetchRequest
        guard let lus = try? PersistenceController.shared.container.viewContext.fetch(request) else { return ""}
        if  lus.count > 0 {
            token = lus.first?.token ?? ""
        }
        return token
    }
    
    
    
}

