//
//  Constants.swift
//  PokemonApplication
//
//  Created by Yuliya on 21/04/2023.
//

import Foundation
import Alamofire

enum ConstantsOffset: CGFloat {
    case sideOffset = 20
    case topBottomOffset = 30
    case sizeImage = 120
    case widthCustomView = 300
    case heightCustomView = 350
    case cornerRadius = 15
}

enum PokemonsRouter {
    case pokemons(offset: String, limit: String)
    
    enum QueryItems: String {
        case offset
        case limit
    }
    
    var basePath: URL {
        URL(string: "https://pokeapi.co")!
    }
    
    var path: String {
        switch self {
        case .pokemons:
            return "api/v2/pokemon"
        }
    }
    
    var queryParameters: [String: String] {
        switch self {
        case let .pokemons(offset: offset, limit: limit):
            return [QueryItems.offset.rawValue : offset, QueryItems.limit.rawValue : limit]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .pokemons:
            return .get
        }
    }
}
