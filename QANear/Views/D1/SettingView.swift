//
//  SettingView.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/01.
//  Copyright © 2019 OneV's Den. All rights reserved.
//
import SwiftUI
import Kingfisher
import CoreData

struct SettingView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @EnvironmentObject var store: Store
    var settingsBinding: Binding<AppState.Settings> {
        $store.appState.settings
    }
    
    var settings: AppState.Settings {
        store.appState.settings
    }

    var body: some View {
        Form {
            accountSection
            if(settings.loginSuc){
                optionSection
                actionSection
            }
        }
        .alert(item: settingsBinding.loginError) { error in
            Alert(title: Text(error.localizedDescription))
        }
    }

    var accountSection: some View {
        Section(header: Text("账户")) {
            if settings.loginUser == nil {
                Picker(selection: settingsBinding.checker.accountBehavior, label: Text("")) {
                    ForEach(AppState.Settings.AccountBehavior.allCases, id: \.self) {
                        Text($0.text)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("手机号", text: settingsBinding.checker.mobile)
                    .foregroundColor(.green)
                SecureField("密码", text: settingsBinding.checker.password)
                if settings.checker.accountBehavior == .register {
                    SecureField("确认密码", text: settingsBinding.checker.verifyPassword)
                }
                if settings.loginRequesting {
                    Text("请求中...")
                } else {
                    Button(settings.checker.accountBehavior.text) {
                        if(settings.checker.accountBehavior == .login){
                            self.store.dispatch(
                                .login(
                                    mobile: self.settings.checker.mobile,
                                    password: self.settings.checker.password
                                )
                            )
                        }else if(settings.checker.accountBehavior == .register){
                            self.store.dispatch(.register(mobile: self.settings.checker.mobile, password: self.settings.checker.password, verifyPass: self.settings.checker.verifyPassword))
                        }
                    }
                }
            } else {
                Text(settings.loginUser!.mobile)
                    .onAppear{
                        do {
                            let request = LU.sortedFetchRequest
                            guard let lus = try? managedObjectContext.fetch(request) else {return }
                            if  lus.count > 0 {//更新
                                let lu:LU = lus.first!
                                lu.mobile = settings.loginUser!.mobile
                                lu.token  = settings.loginUser!.token
                                managedObjectContext.saveOrRollback()
                            }else {//新增
                                managedObjectContext.performChanges {
                                    LU.insert(into: self.managedObjectContext, mobile: settings.loginUser!.mobile, token: settings.loginUser!.token)
                                
                                }
                            }
                        }
                    }
                Button("注销") {
                    self.store.dispatch(.logout)
                }
            }
        }
        
    }

    
    var optionSection: some View {
        Section(header: Text("选项")) {
            
                HStack{
                    KFImage.url(URL(string: settings.loginUser?.headImg ?? "")).resizable()
                        .fade(duration: 1)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .cornerRadius(8)
                    Spacer()
                    Text("\(settings.loginUser?.nickName ?? "")")
                }


//            Toggle(isOn: settingsBinding.showEnglishName) {
//                Text("显示英文名")
//            }
//            Picker(selection: settingsBinding.sorting, label: Text("排序方式")) {
//                ForEach(AppState.Settings.Sorting.allCases, id: \.self) {
//                    Text($0.text)
//                }
//            }
//            Toggle(isOn: settingsBinding.showFavoriteOnly) {
//                Text("只显示收藏")
//            }
        }
    }

    var actionSection: some View {
        Section {
            Button(action: {
                self.store.dispatch(.clearCache)
            }) {
                Text("清空缓存").foregroundColor(.red)
            }
        }
    }
    
    
}

extension AppState.Settings.Sorting {
    var text: String {
        switch self {
        case .id: return "ID"
        case .name: return "名字"
        case .color: return "颜色"
        case .favorite: return "最爱"
        }
    }
}

extension AppState.Settings.AccountBehavior {
    var text: String {
        switch self {
        case .register: return "注册"
        case .login: return "登录"
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.settings.sorting = .color

        return SettingView().environmentObject(store)
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)

    }
}
