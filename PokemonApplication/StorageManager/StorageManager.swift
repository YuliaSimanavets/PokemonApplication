//
//  StorageManager.swift
//  PokemonApplication
//
//  Created by Yuliya on 16/04/2023.
//

import Foundation
import CoreData

protocol StorageManagerProtocol {
    func getPokemonsFromDataBase() -> [PokemonEntity]
    func savePokemonsToDatabase(pokemons: [PokemonModel])
    func deletePokemonsFromDataBase()
}

class PokemonStorageManager: StorageManagerProtocol {
    
    let context = CoreDataManager.shared.context
    
    func getPokemonsFromDataBase() -> [PokemonEntity] {
        
        let request = NSFetchRequest<PokemonEntity>(entityName: "PokemonEntity")
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching")
        }
        return []
    }
    
    func savePokemonsToDatabase(pokemons: [PokemonModel]) {
        
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
        
        let request = NSFetchRequest<PokemonEntity>(entityName: "PokemonEntity")
        do {
            let result = try context.fetch(request)
            for item in result {
                context.delete(item)
            }
            try context.save()
        } catch let error as NSError {
            print("Could not fetch or delete. \(error), \(error.userInfo)")
        }
    }
}
