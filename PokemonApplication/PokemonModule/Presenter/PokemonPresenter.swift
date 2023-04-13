//
//  MainPokemonPresenter.swift
//  PokemonApplication
//
//  Created by Yuliya on 11/04/2023.
//

import Foundation
import UIKit

protocol PokemonViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
    var activityIndicator: UIActivityIndicatorView { get set }
}

protocol PokemonViewPresenterProtocol: AnyObject {
    init(view: PokemonViewProtocol, dataManager: DataManagerProtocol)
    var pokemons: [PokemonModel]? { get set }
    func getPokemons()
}

class PokemonPresenter: PokemonViewPresenterProtocol {
    
    weak var view: PokemonViewProtocol?
    var dataManager: DataManagerProtocol!
    var pokemons: [PokemonModel]?
    
    required init(view: PokemonViewProtocol, dataManager: DataManagerProtocol) {
        self.view = view
        self.dataManager = dataManager
        getPokemons()
    }
    
    func getPokemons() {
        dataManager.getPokemons { [weak self] pokemons in
            guard let self = self else { return }
            
            self.pokemons = pokemons.map({ PokemonModel(name: $0.name, url: $0.url) })
            self.view?.activityIndicator.stopAnimating()
            print("PokemonPresenter: \(String(describing: pokemons))")
        }
    }
}
