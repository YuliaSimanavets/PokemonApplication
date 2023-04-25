//
//  StorageManager.swift
//  PokemonApplication
//
//  Created by Yuliya on 16/04/2023.
//

import Foundation
import CoreData
import UIKit

protocol StorageManagerProtocol {
    func getPokemonsFromDataBase() -> [PokemonEntity]
    func savePokemonsToDatabase(pokemons: [PokemonModel])
}

final class PokemonStorageManager: StorageManagerProtocol {
    var coreDataManager: CoreDataManagerProtocol?

    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
    
    func getPokemonsFromDataBase() -> [PokemonEntity] {
        
        let request = NSFetchRequest<PokemonEntity>(entityName: "PokemonEntity")
        guard let context = coreDataManager?.context else { return [] }
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching")
        }
        return []
    }
    
    func savePokemonsToDatabase(pokemons: [PokemonModel]) {
        guard let context = coreDataManager?.context else { return }
        for item in pokemons {
            let fetchRequest: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "url == %@", item.url)
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.first != nil {
                    continue
                } else {
                    guard let pokemonEntity = NSEntityDescription.insertNewObject(forEntityName: "PokemonEntity", into: context) as? PokemonEntity else { return }
                    pokemonEntity.name = item.name
                    pokemonEntity.url = item.url
                }
            } catch let error as NSError {
                print("Core Data Error: \(error), \(error.userInfo)")
            }
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Core Data Error: \(error), \(error.userInfo)")
            }
        }
    }
}
