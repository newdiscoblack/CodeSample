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
    var headers: [String: String]? { get }
    var body: Data? { get }
    var query: [String: String?]? { get }
    var authorizationNeeds: AuthorizationNeeds { get }
}

extension Resource {
    public var headers: [String: String]? { nil }
    public var body: Data? { nil }
    public var query: [String: String?]? { nil }
    public var authorizationNeeds: AuthorizationNeeds { .standard }
}

public enum AuthorizationNeeds {
    case none
    case standard
}

enum RequestMethod: String {
    case GET
    case POST
}
