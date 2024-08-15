//
//  LoginServing.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 15/08/2024.
//

import Foundation

protocol LoginServing {
    func logInWith(
        username: String,
        password: String
    ) async throws -> Authorization
}

extension NetworkClient: LoginServing {
    func logInWith(
        username: String,
        password: String
    ) async throws -> Authorization {
        let resource = try ObtainAuthorization(
            username: username,
            password: password
        )
        return try await request(resource: resource)
    }
}
