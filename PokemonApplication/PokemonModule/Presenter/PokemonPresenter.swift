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

protocol PokemonViewPresenterProtocol {
    var pokemons: [PokemonModel]? { get }
    func getPokemonsFromAPI(limit: Int)
    func getPokemonsFromDB()
    func loadNextPokemons()
}

class PokemonPresenter: PokemonViewPresenterProtocol {
    
    weak var view: PokemonViewProtocol?
    private let dataManager: DataManagerProtocol?
    private let storageManager: StorageManagerProtocol?
    private let reachability: ReachabilityProtocol?
    
    var pokemons: [PokemonModel]?
    private var page = 0
    private let limit = 10
    
    init(view: PokemonViewProtocol,
                  dataManager: DataManagerProtocol,
                  storageManager: StorageManagerProtocol,
                  reachability: ReachabilityProtocol) {
        self.view = view
        self.dataManager = dataManager
        self.storageManager = storageManager
        self.reachability = reachability
        
        reachability.isNetworkAvailable { result in
            if result {
                self.getPokemonsFromAPI(limit: self.limit)
            } else {
                self.getPokemonsFromDB()
            }
        }
    }
    
    func getPokemonsFromAPI(limit: Int) {
        dataManager?.loadPokemons(limit: limit, offset: limit * page) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemons):
                    self.pokemons = pokemons?.map({ PokemonModel(name: $0.name, url: $0.url) })
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
        self.view?.succes()
    }
    
    func loadNextPokemons() {
        page += 1
        getPokemonsFromAPI(limit: limit)
        self.storageManager?.savePokemonsToDatabase(pokemons: pokemons ?? [])
    }
}
