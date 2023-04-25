//
//  DetailsPresenter.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import Foundation
import UIKit
import SDWebImage

protocol DetailsViewProtocol: AnyObject {
    func setPokemon(pokemon: CustomViewModel?)
    func succes()
    func failure(error: Error)
}

protocol DetailsViewPresenterProtocol {
    func getPokemon()
}

class DetailsPresenter: DetailsViewPresenterProtocol {
    
    weak var view: DetailsViewProtocol?
    private let dataManager: DataManagerProtocol?
    private var pokemon: PokemonDetails?
    
    private let pokemonUrl: String
    
    init(view: DetailsViewProtocol, dataManager: DataManagerProtocol, pokemonURL: String) {
        self.view = view
        self.dataManager = dataManager
        self.pokemonUrl = pokemonURL
    }
 
    func getPokemon() {
        dataManager?.loadDetailsPokemon(url: pokemonUrl) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemonDetails):
                    self.pokemon = pokemonDetails
                    self.view?.succes()
                    
                    guard let pokemon = self.pokemon else { return }
                    let url = URL(string: pokemon.sprites.frontDefault)
                    let manager = SDWebImageManager.shared
                    manager.loadImage(with: url, options: [], progress: nil) { (image, _, error, _, _, _) in
                        guard let image = image else { return }
                        self.view?.setPokemon(pokemon: CustomViewModel(pokemonsName: pokemon.name,
                                                                       pokemonsType: pokemon.types[0].type.name,
                                                                       pokemonsHeight: String(pokemon.height),
                                                                       pokemonsWeight: String(pokemon.weight),
                                                                       pokemonsImage: image))
                    }
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
}
