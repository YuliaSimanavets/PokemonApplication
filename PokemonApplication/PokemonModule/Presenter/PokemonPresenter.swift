//
//  MainPokemonPresenter.swift
//  PokemonApplication
//
//  Created by Yuliya on 11/04/2023.
//

import Foundation

protocol PokemonViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
}

protocol PokemonViewPresenterProtocol: AnyObject {
    init(view: PokemonViewProtocol)
    var pokemons: [Pokemon]? { get set }
    func getPokemons()
}

class PokemonPresenter: PokemonViewPresenterProtocol {
    
    weak var view: PokemonViewProtocol?
    var pokemons: [Pokemon]?
    
    required init(view: PokemonViewProtocol) {
        self.view = view
        getPokemons()
    }
    
    func getPokemons() {
        print("hi")
    }
}
