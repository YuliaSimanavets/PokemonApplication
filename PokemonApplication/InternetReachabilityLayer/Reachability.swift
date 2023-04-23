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
