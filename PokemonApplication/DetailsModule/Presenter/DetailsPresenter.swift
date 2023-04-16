//
//  DetailsPresenter.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import Foundation
import UIKit

protocol DetailsViewProtocol: AnyObject {
    func setPokemon(pokemon: CustomViewModel?)
    func succes()
    func failure(error: Error)
}

protocol DetailsViewPresenterProtocol: AnyObject {
    init(view: DetailsViewProtocol, dataManager: DataManagerProtocol, pokemonURL: String)
    var pokemon: PokemonDetails? { get set }
    func getPokemon()
}

class DetailsPresenter: DetailsViewPresenterProtocol {
    
    weak var view: DetailsViewProtocol?
    var dataManager: DataManagerProtocol!
    var pokemon: PokemonDetails?
        
    var pokemonUrl: String

    required init(view: DetailsViewProtocol, dataManager: DataManagerProtocol, pokemonURL: String) {
        self.view = view
        self.dataManager = dataManager
        self.pokemonUrl = pokemonURL
    }
        
    func getPokemon() {
        
        dataManager.getDetailsPokemon(url: pokemonUrl) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemonDetails):
                    self.pokemon = pokemonDetails
                    self.view?.succes()
                    guard let pokemon = self.pokemon else { return }
                    self.view?.setPokemon(pokemon: CustomViewModel(pokemonsName: pokemon.name,
                                                                   pokemonsType: pokemon.types[0].type.name,
                                                                   pokemonsHeight: String(pokemon.height),
                                                                   pokemonsWeight: String(pokemon.weight),
                                                                   pokemonsImage: self.dataManager.getImage(url: pokemon.sprites.frontDefault)))
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
}
