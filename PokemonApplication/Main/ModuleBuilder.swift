//
//  ModuleBuilder.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import UIKit

final class ModuleBuilder {
    
    static func createPokemonModule() -> UIViewController {
        let view = PokemonViewController()
        let dataManager = DataManager()
        let coreDataManager = CoreDataManager()
        let storageManager = PokemonStorageManager(coreDataManager: coreDataManager)
        let reachability = Reachability()
        let presenter = PokemonPresenter(view: view,
                                         dataManager: dataManager,
                                         storageManager: storageManager,
                                         reachability: reachability)
        view.presenter = presenter
        return view
    }
    
    static func createDetailsModule(url: String) -> UIViewController {
        let view = DetailsViewController()
        let dataManager = DataManager()
        let presenter = DetailsPresenter(view: view,
                                         dataManager: dataManager,
                                         pokemonURL: url)
        view.presenter = presenter
        return view
    }
}
