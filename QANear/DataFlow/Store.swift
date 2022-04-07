//
//  Store.swift
//  QANear
//
//  Created by zzr on 2021/10/22.
//

import Foundation
import Combine
import CoreData

class Store: ObservableObject {
    @Published var appState = AppState()
    
    private var disposeBag = Set<AnyCancellable>()

    init() {
        setupObservers()
    }

    func setupObservers() {
        appState.settings.checker.isEmailValid.sink {
            isValid in
            self.dispatch(.emailValid(valid: isValid))
        }.store(in: &disposeBag)
    }
    
    func dispatch (_ action: AppAction){
        #if DEBUG
        print("[ACTION]:\(action)")
        #endif
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        if let command = result.1 {
            #if DEBUG
            print("[COMMAND]:\(command)")
            #endif
            command.execute(in: self)
        }
        
    }
    
    static func reduce(state: AppState, action:AppAction) -> (AppState,AppCommand?){
        var appState = state
        var appCommand: AppCommand?
        
        switch action {
        case .login(let mobile, let password):
            guard !appState.settings.loginRequesting else { break }
            appState.settings.loginRequesting = true
            appCommand = LoginAppCommand(mobile: mobile, password: password)
        case .register(let mobile, let password, let verifyPass):
            guard !appState.settings.loginRequesting else { break }
            appState.settings.loginRequesting = true
            appCommand = RegisterAppCommand(mobile: mobile, password: password, verifyPass: verifyPass)
        case .accountBehaviorDone(let result):
            appState.settings.loginRequesting = false

            switch result {
            case .success(let user):
                appState.settings.loginUser = user
                appState.settings.loginSuc = true
            case .failure(let error):
                appState.settings.loginError = error
                appState.settings.loginSuc = false
            }
        case .logout:
            appState.settings.loginUser = nil
            appState.settings.loginSuc = false
        case .emailValid(let valid):
            appState.settings.isEmailValid = valid
            
        case .loadHotPageData(let searchKey):
            appState.settings.loginSuc = true
            appCommand = loadHotDataCommand(searchKey:searchKey)
        case .loadHotPageDataDone(let result):
            switch result {
            case .success(let models):
                appState.settings.loginSuc = true
                appState.questionList.questions =  Dictionary(uniqueKeysWithValues: models.map{($0.id,$0)})
            case .failure(let error):
                print(error)
            }

        case .clearCache:
            appState.questionList.questions = nil
        case .closeSafariView:
            print("undo")
        
        case .saveQuestion(let coment, let imgArr,let uploaddata):
            appState.settings.loginSuc = true
            appState.settings.showAddQuestionAlert = true
            appCommand = SaveQuestionCommand(comment: coment, imgArr: imgArr, uploaddata: uploaddata, picName: UUID().uuidString)
            
        case .questionDetail(let id):
            appState.settings.loginSuc = true
            appCommand = loadQuestionCommand(id: id)

        case .loadQdDone(let result):
            switch result {
            case .success(let model):
                appState.settings.qd = model
            case .failure(let error):
                print(error)
            }
        }
        
        return (appState, appCommand)
    }
}
