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
    
    enum QueryItems: String{
        case offset
        case limit
    }
    
    var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pokeapi.co"
        components.path = "/api/v2/pokemon"
        return components
    }()

    func getPokemons(limit: Int, offset: Int, completion: @escaping (Result<[Pokemon]?, Error>) -> Void) {
        
        let queryItemOffset = URLQueryItem(name: QueryItems.offset.rawValue, value: String(offset))
        let queryItemLimit = URLQueryItem(name: QueryItems.limit.rawValue, value: String(limit))
        urlComponents.queryItems = [queryItemOffset, queryItemLimit]
        
        guard let url = urlComponents.url?.absoluteString else { return }
        var request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
        URLSession.shared.dataTask(with: request) { data, _, error in
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
