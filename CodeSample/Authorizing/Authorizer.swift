//
//  Authorizer.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 15/08/2024.
//

import Foundation

protocol Authorizing {
    func logInWith(
        username: String,
        password: String
    ) async throws
    func didRestoreAuthorization() -> Bool
}

final class Authorizer: Authorizing {
    private let loginService: LoginServing
    private let keychain: KeychainStoring
    
    init(
        loginService: LoginServing,
        keychain: KeychainStoring
    ) {
        self.loginService = loginService
        self.keychain = keychain
    }
    
    func logInWith(
        username: String,
        password: String
    ) async throws {
        let authorization = try await loginService.logInWith(
            username: username,
            password: password
        )
        try keychain.saveInKeychain(
            authorization,
            keychainKey: .authorization
        )
    }
    
    func didRestoreAuthorization() -> Bool {
        do {
            let authorization: Authorization? = try keychain.readFromKeychain(
                keychainKey: .authorization
            )
            return authorization != nil
        } catch {
            print("didRestoreAuthorization error: ", error)
            return false
        }
    }
}
