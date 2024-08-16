//
//  Resource.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import Foundation

protocol Resource {
    var path: String { get }
    var httpRequestMethod: RequestMethod { get }
    var body: Data? { get }
    var authorizationNeeds: AuthorizationNeeds { get }
}

extension Resource {
    public var body: Data? { nil }
}

public enum AuthorizationNeeds {
    case none
    case standard
}

enum RequestMethod: String {
    case GET
    case POST
}
