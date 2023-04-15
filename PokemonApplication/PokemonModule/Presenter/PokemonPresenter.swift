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
}

protocol PokemonViewPresenterProtocol: AnyObject {
    init(view: PokemonViewProtocol, dataManager: DataManagerProtocol)
    var pokemons: [PokemonModel]? { get set }
    func getPokemonsFromAPI()
}

class PokemonPresenter: PokemonViewPresenterProtocol {
    
    weak var view: PokemonViewProtocol?
    var dataManager: DataManagerProtocol!
    var pokemons: [PokemonModel]?
    
    let context = CoreDataManager.shared.context
    
    required init(view: PokemonViewProtocol, dataManager: DataManagerProtocol) {
        self.view = view
        self.dataManager = dataManager
        getPokemonsFromAPI()
        
        if pokemons == nil {
            pokemons = getPokemonsFromDataBase().map({ PokemonModel(name: $0.name ?? "", url: $0.url ?? "") })
        }
    }
    
    func getPokemonsFromAPI() {
        
        dataManager.getPokemons { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let pokemons):
                    self.pokemons = pokemons?.map({ PokemonModel(name: $0.name, url: $0.url) })
                    self.savePokemons(pokemons: self.pokemons ?? [])
                    self.view?.succes()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func savePokemons(pokemons: [PokemonModel]) {
        
        for pokemon in pokemons {
            savePokemonToDatabase(pokemon: pokemon)
        }
    }
    
    func savePokemonToDatabase(pokemon: PokemonModel) {
        
        guard let pokemonEntity = NSEntityDescription.insertNewObject(forEntityName: "PokemonEntity", into: context) as? PokemonEntity else { return }
        
        pokemonEntity.name = pokemon.name
        pokemonEntity.url = pokemon.url
        
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
}
