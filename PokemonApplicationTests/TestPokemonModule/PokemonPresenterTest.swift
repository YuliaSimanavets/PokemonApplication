//
//  PokemonPresenterTest.swift
//  PokemonApplicationTests
//
//  Created by Yuliya on 23/04/2023.
//

import XCTest
@testable import PokemonApplication

class MockView: PokemonViewProtocol {
    func succes() {
    }
    
    func failure(error: Error) {
    }
}

class MockDataManager: DataManagerProtocol {
    
    var pokemons: [Pokemon]!
    
    init() {}
    
    convenience init(pokemons: [Pokemon]?) {
        self.init()
        self.pokemons = pokemons
    }
    
    func getPokemons(limit: Int, offset: Int, completion: @escaping (Result<[PokemonApplication.Pokemon]?, Error>) -> Void) {
        if let pokemons = pokemons {
            completion(.success(pokemons))
        } else {
            let error = NSError(domain: "", code: 0)
            completion(.failure(error))
        }
    }
    
    func getDetailsPokemon(url: String, completion: @escaping (Result<PokemonApplication.PokemonDetails?, Error>) -> Void) {
    }
    
    func getImage(url: String) -> UIImage? {
        return UIImage(systemName: "home")
    }
}

//class MockStorageManager: StorageManagerProtocol {
//
//    required init(coreDataManager: PokemonApplication.CoreDataManagerProtocol) {
//        <#code#>
//    }
//
//    func getPokemonsFromDataBase() -> [PokemonApplication.PokemonEntity] {
//        return []
//    }
//
//    func savePokemonsToDatabase(pokemons: [PokemonApplication.PokemonModel]) {
//
//    }
//
//    func deletePokemonsFromDataBase() {
//
//    }
//}

class MockReachability: ReachabilityProtocol {
    func isNetworkAvailable() -> Bool {
        return true
    }
}

final class PokemonPresenterTest: XCTestCase {

    var view: MockView!
    var presenter: PokemonPresenter!
    var dataManager: DataManagerProtocol!
//    var storageManager: StorageManagerProtocol!
    var reachabiliry: ReachabilityProtocol!
    var pokemons: [Pokemon]!
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        view = nil
        presenter = nil
        dataManager = nil
//        storageManager = nil
        reachabiliry = nil
    }

    func testGetSuccesPokemons() {
        let pokemon = Pokemon(name: "Foo", url: "Baz")
        pokemons.append(pokemon)
        view = MockView()
//        storageManager = MockStorageManager()
        reachabiliry = MockReachability()
        dataManager = MockDataManager(pokemons: [pokemon])
        
//        presenter = PokemonPresenter(view: view!, dataManager: dataManager!, storageManager: storageManager, reachability: reachabiliry)
        
        dataManager.getPokemons(limit: 1, offset: 0) { result in
            
        }
    }
}
