//
//  CoreDataManager.swift
//  PokemonApplication
//
//  Created by Yuliya on 15/04/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
        
    lazy var persistentContainer: NSPersistentContainer = {
        
        let managedObjectModelName = "PokemonModel"

        let container = NSPersistentContainer(name: managedObjectModelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
