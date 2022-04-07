//
//  SaveQuestionRequest.swift
//  QANear
//
//  Created by zzr on 2021/11/15.
//
import Foundation
import Combine
import Alamofire
import SwiftUI

struct SaveQusetionRequest {
    let comment: String
    let imgArr: String
    let uploaddata: [UIImage?]?
    let picName: String

    let device = Device(mac: "", plat: "iphone", channel: "c11111", lon: "", os: "14.5", w: 414, h: 736, appCodeName: "11", build: "14.5", apiv: "1", IDFA: "0CBC9945-8040-4746-A6A3-287DB3C548DA", appv: "0.0.1", appid: "467D8F6F-CBD1-4B6B-8285-291CD3F822C4", lat: "", province: "", city: "", brand: "Apple", net: "wifi", mid: "iPhone10,2");
    let headers: HTTPHeaders = [
        "token": getToken(),
        "Accept": "application/json"]

    

    public func addQPublisher(for imgArr:String) -> AnyPublisher<String, AppError> {
        Future { promise in
                let addQuestionBody = AddQuestionBody(content: self.comment, imgs: self.imgArr)
                let sign = ""
                let be = Body(device: device, sign: sign, body: addQuestionBody)

                AF.request("http://139.198.14.224:9502/api/order/order/addq", method: .post, parameters: be, encoder: JSONParameterEncoder.default,headers:headers).responseDecodable(of: UResult<String>.self){ response in
                DispatchQueue.main.async {
                    let code = try? response.result.get().code
                    let msg = try? response.result.get().msg
                    if(code == 0){
                        let rst = try! response.result.get().data
                        promise(.success(rst!))
                    }else{
                        promise(.failure(.errorStr(msg ?? "")))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
//    func dealPic() -> AnyPublisher<String, AppError> {
//        fetchImgst().flatMap{ ptoken in
//            return uploadImg(token: ptoken)
//        }
//    }
    
    
    func fetchImgst() -> AnyPublisher<String, AppError> {
        return Future { promise in
            let emptyBody = EmptyBody(emptyStr:"")
            let sign = ""
            let be = Body(device: device, sign: sign, body: emptyBody)

            AF.request("http://139.198.14.224:9502/api/order/order/imgst", method: .post, parameters: be, encoder: JSONParameterEncoder.default,headers:headers).responseDecodable(of: UResult<String>.self){ response in
                let code = try? response.result.get().code
                if(code == 0){
                    let token = try! response.result.get().data
                    promise(.success(token!))
                }
            }
        }.receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func uploadImg(token: String) -> AnyPublisher<[String], AppError>{
        return Future { promise in
            var upNum = 0
            var imgArr = [String]()
            for index in uploaddata!{
                let s = UUID().uuidString
                MyClass.sampleCategoryMethod(token,picName:s,uploaddata: index?.jpegData(compressionQuality: 0.8))
                imgArr.append(s)
                upNum += 1
            }
            print("upNum:\(upNum),imgArr,count:\(imgArr.count)")
            if upNum == imgArr.count {
                promise(.success(imgArr))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func addq(imgArr:[String]) -> AnyPublisher<String, AppError>{
        return Future { promise in
                let addQuestionBody = AddQuestionBody(content: self.comment, imgs: imgArr.joined(separator: ","))
                let sign = ""
                let addq = Body(device: device, sign: sign, body: addQuestionBody)
                    
                AF.request("http://139.198.14.224:9502/api/order/order/addq", method: .post, parameters: addq, encoder: JSONParameterEncoder.default,headers:headers).responseDecodable(of: UResult<String>.self){ response in
                DispatchQueue.main.async {
                    let code = try? response.result.get().code
                    let msg = try? response.result.get().msg
                    if(code == 0){
                        let rst = try! response.result.get().data
                        promise(.success(rst!))
                    }else{
                        promise(.failure(.errorStr(msg ?? "")))
                    }
                }
            }
        }.receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    var publisher : AnyPublisher<String, AppError> {
        Future { promise in
                let emptyBody = EmptyBody(emptyStr:"")
                let sign = ""
                let be = Body(device: device, sign: sign, body: emptyBody)

                AF.request("http://139.198.14.224:9502/api/order/order/imgst", method: .post, parameters: be, encoder: JSONParameterEncoder.default,headers:headers).responseDecodable(of: UResult<String>.self){ response in
                    
                    let code = try? response.result.get().code
                    let msg = try? response.result.get().msg
                    if(code == 0){
                        let token = try! response.result.get().data
                        var upNum = 0
                        var imgArr = [String]()
                        for index in uploaddata!{
                            let s = UUID().uuidString
                            MyClass.sampleCategoryMethod(token,picName:s,uploaddata: index?.jpegData(compressionQuality: 0.8))
                            imgArr.append(s)
                            upNum += 1
                        }
                        
                        print("upNum:\(upNum),imgArr,count:\(imgArr.count)")
                        if upNum == imgArr.count {
                            print("success")
                            let addQuestionBody = AddQuestionBody(content: self.comment, imgs: imgArr.joined(separator: ","))
                            let sign = ""
                            let addq = Body(device: device, sign: sign, body: addQuestionBody)
                                
                            AF.request("http://139.198.14.224:9502/api/order/order/addq", method: .post, parameters: addq, encoder: JSONParameterEncoder.default,headers:headers).responseDecodable(of: UResult<String>.self){ response in
                            DispatchQueue.main.async {
                                let code = try? response.result.get().code
                                let msg = try? response.result.get().msg
                                if(code == 0){
                                    let rst = try! response.result.get().data
                                    promise(.success(rst!))
                                }else{
                                    promise(.failure(.errorStr(msg ?? "")))
                                }
                            }
                        }
                    }else{
                        promise(.failure(.errorStr( "图片上传步骤失败")))
                    }
                }else{
                    promise(.failure(.errorStr( msg ?? "")))
                }
        }
    }
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
}
    
//    public func uploadQuestionImgs() -> String {
//        String token = fetchImgServerTokenPublisher().map(return token)
//
//        fetchImgServerTokenPublisher().flatMap{ token in
//            return MyClass.sampleCategoryMethod(token,uploaddata: "picX")
//        }
//        .flatMap { str in
//            addQPublisher(for: str)
//        }
//    }
        
    public static func getToken() -> String {
        var token = ""
        let request = LU.sortedFetchRequest
        guard let lus = try? PersistenceController.shared.container.viewContext.fetch(request) else { return ""}
        if  lus.count > 0 {
            token = lus.first?.token ?? ""
        }
        return token
    }
    
    
}

