//
//  MainPokemonPresenter.swift
//  PokemonApplication
//
//  Created by Yuliya on 11/04/2023.
//

import UIKit
import CoreData

protocol PokemonViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
    
//    func showData(_ data: [PokemonModel])
//    func disablePagination()
}

protocol PokemonViewPresenterProtocol: AnyObject {
    init(view: PokemonViewProtocol, dataManager: DataManagerProtocol)
    var pokemons: [PokemonModel]? { get set }
    func getPokemonsFromAPIAndPutInDB(limit: Int)
    func loadNextPokemons()
    var page: Int { get set }
}

class PokemonPresenter: PokemonViewPresenterProtocol {
    
    weak var view: PokemonViewProtocol?
    var dataManager: DataManagerProtocol!
    var pokemons: [PokemonModel]?
    
    let context = CoreDataManager.shared.context
    
    var page = 0
    let limit = 10
    
    required init(view: PokemonViewProtocol, dataManager: DataManagerProtocol) {
        self.view = view
        self.dataManager = dataManager
        getPokemonsFromAPIAndPutInDB(limit: limit)
        
        if pokemons == nil {
            pokemons = getPokemonsFromDataBase().map({ PokemonModel(name: $0.name ?? "", url: $0.url ?? "") })
        }
    }
    
    func getPokemonsFromAPIAndPutInDB(limit: Int) {

        dataManager.getPokemons(limit: limit, offset: limit * page) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemons):
                    self.pokemons = pokemons?.map({ PokemonModel(name: $0.name, url: $0.url) })
                    self.view?.succes()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func getAnotherPokemonsFromAPIAndPutInDB(limit: Int) {

        dataManager.getPokemons(limit: limit, offset: limit * page) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemons):
                    guard let newPokemons = pokemons?.map({ PokemonModel(name: $0.name, url: $0.url) }) else { return }
                    for item in newPokemons {
                        self.pokemons?.append(item)
                    }
                    self.deletePokemonsFromDataBase()
                    self.savePokemonsToDatabase(pokemons: self.pokemons ?? [])
                    self.view?.succes()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }

    func loadNextPokemons() {
        page += 1
        getAnotherPokemonsFromAPIAndPutInDB(limit: limit) // or any other limit you want
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
    
    func getPokemonsFromDataBase() -> [PokemonEntity] {
        
        let request = NSFetchRequest<PokemonEntity>(entityName: "PokemonEntity")
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching")
        }
        return []
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
