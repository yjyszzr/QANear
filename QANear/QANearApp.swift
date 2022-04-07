//
//  QANearApp.swift
//  QANear
//
//  Created by zzr on 2021/7/2.
//
import SwiftUI
import CoreData

@main
struct QANearApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Store())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
