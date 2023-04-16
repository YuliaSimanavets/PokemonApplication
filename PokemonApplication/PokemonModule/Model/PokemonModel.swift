//
//  PokemonModel.swift
//  PokemonApplication
//
//  Created by Yuliya on 11/04/2023.
//

import Foundation

struct Pokemons: Decodable {
    let results: [Pokemon]
}

struct Pokemon: Decodable {
    let name: String
    let url: String
}
