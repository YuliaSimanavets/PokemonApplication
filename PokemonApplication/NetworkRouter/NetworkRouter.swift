//
//  NetworkRouter.swift
//  PokemonApplication
//
//  Created by Yuliya on 27/04/2023.
//

import Foundation
import Alamofire

protocol NetworkRouter: URLRequestConvertible, URLConvertible {
    var basePath: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var urlEncodedBody: String { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String]? { get }
}

final class MyRouter: NetworkRouter {
    
    private let router: PokemonsRouter
    
    init(router: PokemonsRouter) {
        self.router = router
    }
    
    var basePath: String { return router.basePath.absoluteString }
    var method: HTTPMethod { return router.method }
    var path: String { return router.path }
    var parameters: Parameters? { return [:] }
    var urlEncodedBody: String { return "" }
    var headers: [String : String] { return [:] }
    var queryParameters: [String : String]? { return router.queryParameters }
    
    func asURLRequest() throws -> URLRequest {
        let url = try basePath.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        if !self.urlEncodedBody.isEmpty {
            let data = Data(urlEncodedBody.utf8)
            urlRequest.httpBody = data
        }
        
        if let queryParameters = queryParameters {
            urlRequest = try URLEncodedFormParameterEncoder().encode(queryParameters, into: urlRequest)
        }

        if let parameters = parameters {
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }

        return urlRequest
    }
    
    func asURL() throws -> URL {
        let url = try basePath.asURL()
        return url.appendingPathComponent(path)
    }
}
