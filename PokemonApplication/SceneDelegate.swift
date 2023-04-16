//
//  SceneDelegate.swift
//  PokemonApplication
//
//  Created by Yuliya on 11/04/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
     
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        
        let pokemonViewController = ModuleBuilder.createPokemonModule()
        let navBar = UINavigationController(rootViewController: pokemonViewController)
        window?.rootViewController = navBar
        window?.makeKeyAndVisible()
    }
}

