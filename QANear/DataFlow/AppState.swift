//
//  AppState.swift
//  QANear
//
//  Created by zzr on 2021/10/22.
//

import Foundation
import Combine

struct AppState {
    var questionList = QuestionList()
    var settings = Settings()
}

extension AppState {
    struct QuestionList {
        var loadingQuestions = false
        
        
        //@FileStorage(directory: .cachesDirectory, fileName: "questions.json")
        var questions:[Int:Question]?
 
//        func ds() -> [Question] {
//            var arrO:[Question] = []
//            guard let qes = questions else {
//                return []
//            }
//            arrO.append(qes[1]!)
//            return arrO
//        }
        
        func displayQuestions() -> [Question] {
            func containsSearchText(_ question: Question) -> Bool {
                return true
            }
    
            guard let qes = questions else {
                return []
            }
            
            var filterFuncs: [(Question) -> Bool] = []
            filterFuncs.append(containsSearchText)
            
            let filterFunc = filterFuncs.reduce({ _ in true}) { r, next in
                return { question in
                    r(question) && next(question)
                }
            }
            
            return qes.values.filter(filterFunc)
        }
        
    }
}

extension AppState {
    struct Settings {
        enum Sorting: CaseIterable {
            case id, name, color, favorite
        }

        enum AccountBehavior: CaseIterable {
            case register, login
        }

        class AccountChecker {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var mobile = ""
            @Published var password = ""
            @Published var verifyPassword = ""

            var isEmailValid: AnyPublisher<Bool, Never> {
                let remoteVerify = $email
                    .debounce(
                        for: .milliseconds(500),
                        scheduler: DispatchQueue.main
                    )
                    .removeDuplicates()
                    .flatMap { email -> AnyPublisher<Bool, Never> in
                        let validEmail = email.isValidEmailAddress
                        let canSkip = self.accountBehavior == .login
                        switch (validEmail, canSkip) {
                        case (false, _):
                            return Just(false).eraseToAnyPublisher()
                        case (true, false):
                            return EmailCheckingRequest(email: email)
                                .publisher
                                .eraseToAnyPublisher()
                        case (true, true):
                            return Just(true).eraseToAnyPublisher()
                        }
                    }

                let emailLocalValid = $email.map { $0.isValidEmailAddress }
                let canSkipRemoteVerify = $accountBehavior.map { $0 == .login }

                return Publishers.CombineLatest3(
                    emailLocalValid, canSkipRemoteVerify, remoteVerify
                )
                .map { $0 && ($1 || $2) }
                .eraseToAnyPublisher()
            }
        }
        
        var qd:Question?//问题详情

        var checker = AccountChecker()

        var isEmailValid: Bool = false
        var showEnglishName = true
        var sorting = Sorting.id
        var showFavoriteOnly = false
        var nickName: String = ""
        var headImg: String = ""

        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: LoginSucUser?

        var loginRequesting = false
        var loginSuc = false
        var loginError: AppError?
        var showAddQuestionAlert = false
    }
}
