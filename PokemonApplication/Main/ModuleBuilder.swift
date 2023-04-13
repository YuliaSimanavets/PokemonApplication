//
//  ModuleBuilder.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import UIKit

protocol Builder {
    static func createPokemonModule() -> UIViewController
    static func createDetailsModule() -> UIViewController
}

class ModuleBuilder: Builder {
    
    static func createPokemonModule() -> UIViewController {
        let view = PokemonViewController()
        let presenter = PokemonPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static func createDetailsModule() -> UIViewController {
        let view = DetailsViewController()
        let presenter = DetailsPresenter(view: view)
        view.presenter = presenter
        return view
    }
}