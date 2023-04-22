//
//  Reachability.swift
//  PokemonApplication
//
//  Created by Yuliya on 22/04/2023.
//

import Foundation
import Network

protocol ReachabilityProtocol {
    func isNetworkAvailable() -> Bool
}

final class Reachability: ReachabilityProtocol {
    
    var pathMonitor: NWPathMonitor!
    var path: NWPath?
    
    lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in
        self.path = path
        if path.status == NWPath.Status.satisfied {
            print("Connected")
        } else if path.status == NWPath.Status.unsatisfied {
            print("Unsatisfied")
        } else if path.status == NWPath.Status.requiresConnection {
            print("RequiresConnection")
        }
    }

       let backgroudQueue = DispatchQueue.global(qos: .background)

       init() {
           pathMonitor = NWPathMonitor()
           pathMonitor.pathUpdateHandler = self.pathUpdateHandler
           pathMonitor.start(queue: backgroudQueue)
       }

       func isNetworkAvailable() -> Bool {
           if let path = self.path {
               if path.status == NWPath.Status.satisfied {
                   return true
               }
           }
           return false
       }
}

/*
 class Reachability: ReachabilityProtocol {
 
 static func isConnectedToNetwork() -> Bool {
 
 var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
 zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
 zeroAddress.sin_family = sa_family_t(AF_INET)
 
 let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
 SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
 }
 
 var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
 if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
 return false
 }
 
 let isReachable = flags == .Reachable
 let needsConnection = flags == .ConnectionRequired
 
 return isReachable && !needsConnection
 
 }
 
 //    weak var view: PokemonViewProtocol?
 //    var dataManager: DataManagerProtocol?
 //    let storageManager: StorageManagerProtocol? = nil
 //    var pokemons: [PokemonModel]?
 //    var page = 0
 //    let limit = 10
 //
 //    let monitor = NWPathMonitor()
 //    let queue = DispatchQueue(label: "InternetConnectionMonitor")
 //
 //    init(view: PokemonViewProtocol, dataManager: DataManagerProtocol, storageManager: StorageManagerProtocol) {
 //        self.view = view
 //        self.dataManager = dataManager
 //        self.storageManager = storageManager
 //        checkInternetConnection()
 //    }
 //
 //    func isConnectedToNetwork() {
 //        monitor.pathUpdateHandler = { [self] pathUpdateHandler in
 //            if pathUpdateHandler.status == .satisfied {
 //                guard let self = self else { return }
 //
 //                dataManager?.getPokemons(limit: limit, offset: limit * page) { [weak self] result in
 //                    guard let self = self else { return }
 //
 //                    DispatchQueue.main.async {
 //                        switch result {
 //                        case .success(let pokemons):
 //                            self.pokemons = pokemons?.map({ PokemonModel(name: $0.name, url: $0.url) })
 //                            self.view?.succes()
 //                        case .failure(let error): break
 //                            self.view?.failure(error: error)
 //                        }
 //                    }
 //                }
 //                self.storageManager?.deletePokemonsFromDataBase()
 //                self.storageManager?.savePokemonsToDatabase(pokemons: self.pokemons ?? [])
 //                print("Internet connection is on.")
 //            } else {
 //
 //                self.pokemons = self.storageManager?.getPokemonsFromDataBase()
 //
 //                print("There's no internet connection.")
 //            }
 //        }
 //        monitor.start(queue: queue)
 //    }
 // }
