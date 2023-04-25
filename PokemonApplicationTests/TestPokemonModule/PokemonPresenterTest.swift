//
//  PokemonPresenterTest.swift
//  PokemonApplicationTests
//
//  Created by Yuliya on 23/04/2023.
//

import XCTest
@testable import PokemonApplication

// MARK: - MockPokemonView
class MockPokemonView: PokemonViewProtocol {
    func succes() {
    }
    
    func failure(error: Error) {
    }
}

// MARK: - MockDataManager
class MockDataManager: DataManagerProtocol {
    
    var pokemons: [Pokemon]!
    
    init() {}
    
    convenience init(pokemons: [Pokemon]?) {
        self.init()
        self.pokemons = pokemons
    }
    
    func loadPokemons(limit: Int, offset: Int, completion: @escaping (Result<[PokemonApplication.Pokemon]?, Error>) -> Void) {
        if let pokemons = pokemons {
            completion(.success(pokemons))
        } else {
            let error = NSError(domain: "", code: 0)
            completion(.failure(error))
        }
    }
    
    func loadDetailsPokemon(url: String, completion: @escaping (Result<PokemonApplication.PokemonDetails?, Error>) -> Void) {
    }
}

// MARK: - MockStorageManager
class MockStorageManager: StorageManagerProtocol {
    required init(coreDataManager: PokemonApplication.CoreDataManagerProtocol) {
    }
    
    func getPokemonsFromDataBase() -> [PokemonApplication.PokemonEntity] {
        return []
    }
    
    func savePokemonsToDatabase(pokemons: [PokemonApplication.PokemonModel]) {
    }
}

// MARK: - MockReachability
class MockReachability: ReachabilityProtocol {
    func isNetworkAvailable(completion: @escaping (Bool) -> ()) {
    }
}

final class PokemonPresenterTest: XCTestCase {

    var view: MockPokemonView!
    var presenter: PokemonPresenter!
    var dataManager: DataManagerProtocol!
    var storageManager: StorageManagerProtocol!
    var reachabiliry: ReachabilityProtocol!
    var coreDataManager: CoreDataManagerProtocol!
    var pokemons = [Pokemon]()
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        view = nil
        presenter = nil
        dataManager = nil
        storageManager = nil
        reachabiliry = nil
    }

    func testGetSuccesPokemons() {
        let pokemon = Pokemon(name: "Foo", url: "Baz")
        pokemons.append(pokemon)
        
        view = MockPokemonView()
        coreDataManager = CoreDataManager()
        storageManager = MockStorageManager(coreDataManager: coreDataManager)
        reachabiliry = MockReachability()
        dataManager = MockDataManager(pokemons: [pokemon])
        presenter = PokemonPresenter(view: view!, dataManager: dataManager!, storageManager: storageManager, reachability: reachabiliry)
        
        var catchPokemons: [Pokemon]?
        
        dataManager.loadPokemons(limit: 1, offset: 0) { result in
            switch result {
            case .success(let pokemons):
                catchPokemons = pokemons
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        XCTAssertNotEqual(catchPokemons?.count, 0)
        XCTAssertEqual(catchPokemons?.count, pokemons.count)
    }
    
    func testGetFeilurePokemons() {
        view = MockPokemonView()
        coreDataManager = CoreDataManager()
        storageManager = MockStorageManager(coreDataManager: coreDataManager)
        reachabiliry = MockReachability()
        dataManager = MockDataManager()
        presenter = PokemonPresenter(view: view!, dataManager: dataManager!, storageManager: storageManager, reachability: reachabiliry)
        
        var catchError: Error?
        
        dataManager.loadPokemons(limit: 1, offset: 0) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                catchError = error
            }
        }
        XCTAssertNotNil(catchError)
    }
}
