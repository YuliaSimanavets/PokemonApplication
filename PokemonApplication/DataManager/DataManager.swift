//
//  DataManager.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import Foundation

protocol DataManagerProtocol {
    func getPokemons(completion: @escaping ([Pokemon]) -> ())
}

class DataManager: DataManagerProtocol {
    
    func getPokemons(completion: @escaping ([Pokemon]) -> ()) {
        
        let urlString = "https://pokeapi.co/api/v2/pokemon"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil {
                print("error")
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let responseData = data {
                
                let pokemonData = try? JSONDecoder().decode(Pokemons.self, from: responseData)
                
                print("pokemonData: \(pokemonData?.results.count)")
                DispatchQueue.main.async {
                    completion(pokemonData?.results ?? [])
                }
            }
        }
        task.resume()
    }
}
