//
//  DataManager.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import Foundation
import Alamofire

protocol DataManagerProtocol {
    func loadPokemons(with router: NetworkRouter, completion: @escaping (Result<[Pokemon]?, Error>) -> Void)
    func loadDetailsPokemon(url: String, completion: @escaping (Result<PokemonDetails?, Error>) -> Void)
}

final class DataManager: DataManagerProtocol {

    func loadPokemons(with router: NetworkRouter, completion: @escaping (Result<[Pokemon]?, Error>) -> Void) {

        AF.request(router)
            .responseDecodable(of: Pokemons.self) { (response) in
                guard let data = response.data else {
                    if let error = response.error {
                        completion(.failure(error))
                    }
                    return
                }
                do {
                    let pokemonsData = try JSONDecoder().decode(Pokemons.self, from: data)
                    completion(.success(pokemonsData.results))
                } catch {
                    completion(.failure(error))
                }
            }
    }

    func loadDetailsPokemon(url: String, completion: @escaping (Result<PokemonDetails?, Error>) -> Void) {
        
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .response { response in
            guard let data = response.data else {
                if let error = response.error {
                    completion(.failure(error))
                }
                return
            }
            do {
                let pokemonData = try JSONDecoder().decode(PokemonDetails.self, from: data)
                completion(.success(pokemonData))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
}
