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
         storageManager: StorageManagerProtocol,
         reachability: ReachabilityProtocol)
    var pokemons: [PokemonModel]? { get }
    func getPokemonsFromAPI(limit: Int)
    func getPokemonsFromDB()
//    func getAnotherPokemonsFromAPIAndPutInDB(limit: Int)
    func loadNextPokemons()
}

class PokemonPresenter: PokemonViewPresenterProtocol {
    
    weak var view: PokemonViewProtocol?
    var dataManager: DataManagerProtocol?
    let storageManager: StorageManagerProtocol?
    let reachability: ReachabilityProtocol?
    
    var pokemons: [PokemonModel]?
    var page = 0
    let limit = 10
    
    required init(view: PokemonViewProtocol, dataManager: DataManagerProtocol, storageManager: StorageManagerProtocol, reachability: ReachabilityProtocol) {
        self.view = view
        self.dataManager = dataManager
        self.storageManager = storageManager
        self.reachability = reachability
        
        if reachability.isNetworkAvailable() {
            getPokemonsFromAPI(limit: limit)
        } else {
            getPokemonsFromDB()
        }
    }
    
    func getPokemonsFromAPI(limit: Int) {

        dataManager?.getPokemons(limit: limit, offset: limit * page) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemons):
                    self.pokemons = pokemons?.map({ PokemonModel(name: $0.name, url: $0.url) })
//                    self.storageManager?.deletePokemonsFromDataBase()
                    self.storageManager?.savePokemonsToDatabase(pokemons: self.pokemons ?? [])
                    self.view?.succes()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func getPokemonsFromDB() {
        self.pokemons = storageManager?.getPokemonsFromDataBase().map({ PokemonModel(name: $0.name ?? "", url: $0.url ?? "") })
    }
 /*
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
*/
    
//  need to fix
    func loadNextPokemons() {
        page += 1
        getPokemonsFromAPI(limit: limit)
//        getAnotherPokemonsFromAPIAndPutInDB(limit: limit)
    }
}
