//
//  DataManager.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import Foundation
import Alamofire

protocol DataManagerProtocol {
    func loadPokemons(with router: NetworkRouterProtocol, completion: @escaping (Result<[Pokemon]?, Error>) -> Void)
    func loadDetailsPokemon(url: String, completion: @escaping (Result<PokemonDetails?, Error>) -> Void)
}

final class DataManager: DataManagerProtocol {

    func loadPokemons(with router: NetworkRouterProtocol, completion: @escaping (Result<[Pokemon]?, Error>) -> Void) {
        AF.request(router)
            .responseDecodable(of: Pokemons.self) { response in
                switch response.result {
                case .success(let pokemonsData):
                    completion(.success(pokemonsData.results))
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 400...499:
                            if let data = response.data, let errorMessage = try? JSONDecoder().decode(ErrorMessage.self, from: data) {
                                print("Client side error: \(errorMessage.message)")
                                completion(.failure(APIError.client(errorMessage.message)))
                            } else {
                                print("Client side error")
                                completion(.failure(APIError.client("")))
                            }
                        case 500...599:
                            print("Server side error")
                            completion(.failure(APIError.server))
                        default:
                            print("Unknown error")
                            completion(.failure(APIError.unknown))
                        }
                    } else {
                        print("Connection error: \(error.localizedDescription)")
                        completion(.failure(APIError.connection(error)))
                    }
                }
            }
    }

    func loadDetailsPokemon(url: String, completion: @escaping (Result<PokemonDetails?, Error>) -> Void) {
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .responseData { responseData in
            guard let data = responseData.data else {
                if let error = responseData.error {
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
