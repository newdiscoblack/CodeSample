//
//  AuthorizationProviding.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 16/08/2024.
//

import Foundation

protocol AuthorizationProviding {
    func getStandardAuthorizationToken() -> String?
}

extension Keychain: AuthorizationProviding {
    func getStandardAuthorizationToken() -> String? {
        let authorization: Authorization? = try? readFromKeychain(
            keychainKey: .authorization
        )
        return authorization?.token
    }
}
