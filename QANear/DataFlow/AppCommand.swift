//
//  AppCommand.swift
//  QANear
//
//  Created by zzr on 2021/10/22.
//
import Foundation
import Combine
import UIKit

protocol AppCommand {
    func execute(in store: Store)
}

struct LoginAppCommand: AppCommand {
    let mobile: String
    let password: String

    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoginRequest(
            mobile: mobile,
            password: password
        ).publisher
        .sink(
            receiveCompletion: { complete in
                if case .failure(let error) = complete {
                    store.dispatch(
                        .accountBehaviorDone(result: .failure(error))
                    )
                }
                token.unseal()
            },
            receiveValue: { user in
                store.dispatch(
                    .accountBehaviorDone(result: .success(user))
                )
            }
        )
        .seal(in: token)
    }
}

struct SaveQuestionCommand: AppCommand {
    let comment: String
    let imgArr: String
    let uploaddata: [UIImage?]?
    let picName: String

//    func execute(in store: Store) {
//        let token = SubscriptionToken()
//
//        SaveQusetionRequest(
//            comment: comment,
//            imgArr: imgArr,
//            uploaddata: uploaddata,
//            picName: picName
//        ).fetchImgst()
//        .flatMap{ imgtoken in
//            SaveQusetionRequest.uploaddata(imgtoken)
//                .flatMap{ imgArr in
//                    return SaveQusetionRequest.addq(imgArr)
//                }
//        }
//        .sink(
//            receiveCompletion: { complete in
//                if case .failure(let error) = complete {
//                    print("\(error)")
//                }
//                token.unseal()
//            },
//            receiveValue: { str in
//                store.dispatch(
//                    store.dispatch(.loadHotPageDataDone(result: .success(str)))
//                )
//                print("un do")
//            }
//        )
//        .seal(in: token)
//    }
}


struct RegisterAppCommand: AppCommand {
    let mobile: String
    let password: String
    let verifyPass: String

    func execute(in store: Store) {
        let token = SubscriptionToken()
        RegisterRequest(
            mobile: mobile,
            password: password,
            verifyPass: verifyPass
        ).publisher
        .sink(
            receiveCompletion: { complete in
                if case .failure(let error) = complete {
                    store.dispatch(
                        .accountBehaviorDone(result: .failure(error))
                    )
                }
                token.unseal()
            },
            receiveValue: { user in
                store.dispatch(
                    .accountBehaviorDone(result: .success(user))
                )
            }
        )
        .seal(in: token)
    }
}

struct loadHotDataCommand:AppCommand {
    let searchKey: String
    func execute(in store: Store) {
        let token  = SubscriptionToken()
        LoadHotDataRequest(searchKey:searchKey).publisher.sink(
            receiveCompletion:{complete in
                if case .failure(let error) = complete {
                    store.dispatch(.loadHotPageDataDone(result: .failure(error)))
                }
                token.unseal()
                
            },receiveValue:{value in
                store.dispatch(.loadHotPageDataDone(result: .success(value)))
                
            }).seal(in:token)
    }
}

struct loadQuestionCommand:AppCommand {
    let id: String
    func execute(in store: Store) {
        let token  = SubscriptionToken()
        LoadQuestionRequest(id:id).publisher.sink(
            receiveCompletion:{complete in
                if case .failure(let error) = complete {
                    store.dispatch(.loadQdDone(result: .failure(error)))
                }
                token.unseal()
                
            },receiveValue:{value in
                store.dispatch(.loadQdDone(result: .success(value)))
            }).seal(in:token)
    }
}

class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
