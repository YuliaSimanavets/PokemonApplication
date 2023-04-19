//
//  ModuleBuilder.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import UIKit

protocol Builder {
    static func createPokemonModule() -> UIViewController
    static func createDetailsModule(url: String) -> UIViewController
}

class ModuleBuilder: Builder {
    
    static func createPokemonModule() -> UIViewController {
        let view = PokemonViewController()
        let dataManager = DataManager()
        let storageManager = PokemonStorageManager()
        let presenter = PokemonPresenter(view: view,
                                         dataManager: dataManager,
                                         storageManager: storageManager)
        view.presenter = presenter
        view.view.backgroundColor = .lightGray
        return view
    }
    
    static func createDetailsModule(url: String) -> UIViewController {
        let view = DetailsViewController()
        let dataManager = DataManager()
        let presenter = DetailsPresenter(view: view,
                                         dataManager: dataManager,
                                         pokemonURL: url)
        view.presenter = presenter
        view.title = "Pokemon Details"
        view.view.backgroundColor = .lightGray
        return view
    }
}
