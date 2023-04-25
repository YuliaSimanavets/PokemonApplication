//
//  Reachability.swift
//  PokemonApplication
//
//  Created by Yuliya on 22/04/2023.
//

import Foundation
import Network

protocol ReachabilityProtocol {
    func isNetworkAvailable(completion: @escaping (Bool) -> ())
}

final class Reachability: ReachabilityProtocol {
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "IsNetworkAvailable")
    
    func isNetworkAvailable(completion: @escaping (Bool) -> ()) {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                completion(true)
            } else {
                completion(false)
            }
        }
        monitor.start(queue: queue)
    }
}
