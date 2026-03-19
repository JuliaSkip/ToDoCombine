//
//  PersistenceController.swift
//  Skip05
//
//  Created by Скіп Юлія Ярославівна on 20.02.2026.
//

import CoreData


struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Skip05")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            if let url = storeDescription.url {
                print("Core Data SQLite file is located at: \(url.path)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
