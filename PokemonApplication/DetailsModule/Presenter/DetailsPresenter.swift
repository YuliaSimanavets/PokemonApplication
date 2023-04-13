//
//  DetailsPresenter.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import Foundation

protocol DetailsViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
}

protocol DetailsViewPresenterProtocol: AnyObject {
    init(view: DetailsViewProtocol)
    var pokemon: Pokemon? { get set }
    func getPokemon()
}

class DetailsPresenter: DetailsViewPresenterProtocol {
    
    weak var view: DetailsViewProtocol?
    var pokemon: Pokemon?
    
    required init(view: DetailsViewProtocol) {
        self.view = view
        getPokemon()
    }
        
    func getPokemon() {
        print("DetailsPresenter")
    }
}
