//
//  DetailsPokemonModel.swift
//  PokemonApplication
//
//  Created by Yuliya on 13/04/2023.
//

import Foundation

struct PokemonDetails: Codable {
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonType]
    let sprites: Sprites
}

struct PokemonType: Codable {
    let type: Species
}

struct Species: Codable {
    let name: String
}

struct Sprites: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
