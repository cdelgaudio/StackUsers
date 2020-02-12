//
//  ApiRequest.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 12/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import Foundation

// Post request are not required
enum ApiRequest {
    case users(number: Int)
    
    var url: URL? {
        var urlComponents: URLComponents = .init()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = params
        return urlComponents.url
    }
    
    private var scheme: String { "https" }
    
    private var host: String {
        switch self {
        case .users:
            return "api.stackexchange.com"
        }
    }
    
    private var path: String {
        switch self {
        case .users:
            return "/2.2/users"
        }
    }
    
    private var params: [URLQueryItem]? {
        switch self {
        case .users(let pagesize):
            return [
            .init(name: "pagesize", value: "\(pagesize)"),
            .init(name: "order", value: "desc"),
            .init(name: "sort", value: "reputation"),
            .init(name: "site", value: "stackoverflow")
            ]
        }
    }
}
