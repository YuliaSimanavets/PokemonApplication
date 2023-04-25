//
//  DataManager.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import Foundation
import UIKit

protocol DataManagerProtocol {
    func loadPokemons(limit: Int, offset: Int, completion: @escaping (Result<[Pokemon]?, Error>) -> Void)
    func loadDetailsPokemon(url: String, completion: @escaping (Result<PokemonDetails?, Error>) -> Void)
}

final class DataManager: DataManagerProtocol {
    
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

    func loadPokemons(limit: Int, offset: Int, completion: @escaping (Result<[Pokemon]?, Error>) -> Void) {
        
        let queryItemOffset = URLQueryItem(name: QueryItems.offset.rawValue, value: String(offset))
        let queryItemLimit = URLQueryItem(name: QueryItems.limit.rawValue, value: String(limit))
        urlComponents.queryItems = [queryItemOffset, queryItemLimit]
        
        guard let url = urlComponents.url?.absoluteString else { return }
        let request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
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
 
    func loadDetailsPokemon(url: String, completion: @escaping (Result<PokemonDetails?, Error>) -> Void) {

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
}
