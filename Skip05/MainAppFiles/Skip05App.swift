//
//  Skip05App.swift
//  Skip05
//
//  Created by Скіп Юлія Ярославівна on 20.02.2026.
//

import SwiftUI
import CoreData

@main
struct Skip05App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView(service: CDTaskService(context: persistenceController.container.viewContext))
        }
    }
}
