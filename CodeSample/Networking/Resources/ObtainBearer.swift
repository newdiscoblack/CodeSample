//
//  ObtainBearer.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import Foundation

struct ObtainBearer: Resource {
    let path: String = "v1/tokens"
    let httpRequestMethod: RequestMethod = .POST
    let body: Data?
    let authorizationNeeds: AuthorizationNeeds = .none
    
    init(username: String, password: String) throws {
        struct Body: Encodable {
            let username: String
            let password: String
        }
        self.body = try JSONEncoder().encode(
            Body(username: username, password: password)
        )
    }
}

/*
 To generate authorization token, send POST request to
 https://playground.nordsec.com/v1/tokens.
 Request body:
 {"username": "tesonet", "password": "partyanimal"}
 */
