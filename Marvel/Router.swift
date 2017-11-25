//
//  Router.swift
//  Marvel
//
//  Created by Emil Marashliev on 10/28/17.
//  Copyright © 2017 Emil Marashliev. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {
    case comics(parameters: Parameters)

    static let baseURLString = "https://gateway.marvel.com/v1/public/"

    var method: HTTPMethod {
        switch self {
        case .comics:
            return .get
        }
    }

    var path: String {
        switch self {
        case .comics:
            return "comics"
        }
    }

    // MARK: URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .comics(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)

        }

        return urlRequest
    }
}
