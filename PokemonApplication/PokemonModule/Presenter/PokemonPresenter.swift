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
    init(view: PokemonViewProtocol,
         dataManager: DataManagerProtocol,
         storageManager: StorageManagerProtocol)
    var pokemons: [PokemonModel]? { get }
    func getPokemonsFromAPI(limit: Int)
    func getAnotherPokemonsFromAPIAndPutInDB(limit: Int)
    func loadNextPokemons()
}

class PokemonPresenter: PokemonViewPresenterProtocol {
    
    weak var view: PokemonViewProtocol?
    var dataManager: DataManagerProtocol?
    let storageManager: StorageManagerProtocol?
    
    var pokemons: [PokemonModel]?
    var page = 0
    let limit = 10
    
    required init(view: PokemonViewProtocol, dataManager: DataManagerProtocol, storageManager: StorageManagerProtocol) {
        self.view = view
        self.dataManager = dataManager
        self.storageManager = storageManager
        getPokemonsFromAPI(limit: limit)
        pokemons = pokemons ?? storageManager.getPokemonsFromDataBase().map({ PokemonModel(name: $0.name ?? "", url: $0.url ?? "") })
    }
    
    func getPokemonsFromAPI(limit: Int) {

        dataManager?.getPokemons(limit: limit, offset: limit * page) { [weak self] result in
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

        dataManager?.getPokemons(limit: limit, offset: limit * page) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemons):
                    guard let newPokemons = pokemons?.map({ PokemonModel(name: $0.name, url: $0.url) }) else { return }
                    for item in newPokemons {
                        self.pokemons?.append(item)
                    }
                    self.storageManager?.deletePokemonsFromDataBase()
                    self.storageManager?.savePokemonsToDatabase(pokemons: self.pokemons ?? [])
                    self.view?.succes()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }

    func loadNextPokemons() {
        page += 1
        getAnotherPokemonsFromAPIAndPutInDB(limit: limit)
    }
}
