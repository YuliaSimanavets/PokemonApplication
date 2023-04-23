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
    init(coreDataManager: CoreDataManagerProtocol)
    func getPokemonsFromDataBase() -> [PokemonEntity]
    func savePokemonsToDatabase(pokemons: [PokemonModel])
    func deletePokemonsFromDataBase()
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
            guard let pokemonEntity = NSEntityDescription.insertNewObject(forEntityName: "PokemonEntity", into: context) as? PokemonEntity else { return }
            pokemonEntity.name = item.name
            pokemonEntity.url = item.url
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Core Data Error: \(error), \(error.userInfo)")
            }
        }
    }
    
    func deletePokemonsFromDataBase() {
        guard let context = coreDataManager?.context else { return }
        let request = NSFetchRequest<PokemonEntity>(entityName: "PokemonEntity")
        do {
            let result = try context.fetch(request)
            for item in result {
                context.delete(item)
            }
            try context.save()
        } catch let error as NSError {
            print("Could not fetch or delete. \(error.localizedDescription), \(error.userInfo)")
        }
    }
}
