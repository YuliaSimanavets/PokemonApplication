//
//  DataManager.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import Foundation
import UIKit

protocol DataManagerProtocol {
    func getPokemons(limit: Int, offset: Int, completion: @escaping (Result<[Pokemon]?, Error>) -> Void)
    func getDetailsPokemon(url: String, completion: @escaping (Result<PokemonDetails?, Error>) -> Void)
    func getImage(url: String) -> UIImage?
}

class DataManager: DataManagerProtocol {
    
    func getPokemons(limit: Int, offset: Int, completion: @escaping (Result<[Pokemon]?, Error>) -> Void) {
        
        let urlString = "https://pokeapi.co/api/v2/pokemon" + "?" + "offset=\(offset)" + "&" + "limit=\(limit)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let pokemonsData = try JSONDecoder().decode(Pokemons.self, from: data!)
                completion(.success(pokemonsData.results))
                
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
 
    func getDetailsPokemon(url: String, completion: @escaping (Result<PokemonDetails?, Error>) -> Void) {

        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let pokemonData = try JSONDecoder().decode(PokemonDetails.self, from: data!)
                completion(.success(pokemonData))
                
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }

    func getImage(url: String) -> UIImage? {
        
        guard let imageURL = URL(string: url) else { return nil }
        var pokemonImage: UIImage?
        
        do {
            let imageData = try? Data(contentsOf: imageURL)
            pokemonImage = UIImage(data: imageData!)

        } catch {
            print(error.localizedDescription)
        }
        
        return pokemonImage
    }
}
