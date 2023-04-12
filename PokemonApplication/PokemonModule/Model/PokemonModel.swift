//
//  PokemonModel.swift
//  PokemonApplication
//
//  Created by Yuliya on 11/04/2023.
//

import Foundation

struct Pokemons: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
}
