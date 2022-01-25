//
//  PersistenceController.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 24.01.2022.
//

import Foundation
import CoreData

struct PersistenceController {
    let container: NSPersistentContainer

    static let shared = PersistenceController()

    // Convenience
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        let newCompany = Account(context: viewContext)

        shared.saveContext()
        
        return result
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Database") // else UnsafeRawBufferPointer with negative count
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    // Better save
    func saveContext() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
