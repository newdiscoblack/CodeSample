//
//  Authorizer.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 15/08/2024.
//

import Combine
import Foundation

protocol Authorizing {
    var isAuthorized: AnyPublisher<Bool, Never> { get }
    func restoreAuthorizationStatus()
    func logInWith(
        username: String,
        password: String
    ) async throws
    func logOut()
}

final class Authorizer: Authorizing {
    private let loginService: LoginServing
    private let keychain: KeychainStoring
    
    public var isAuthorized: AnyPublisher<Bool, Never> {
        isAuthorizedSubject.eraseToAnyPublisher()
    }
    private let isAuthorizedSubject = CurrentValueSubject<Bool, Never>(false)
    
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
        //TODO: error when no auth?
        let authorization = try await loginService.logInWith(
            username: username,
            password: password
        )
        try keychain.saveInKeychain(
            authorization,
            keychainKey: .authorization
        )
        isAuthorizedSubject.send(true)
    }
    
    func logOut() {
        keychain.clear(.authorization)
        isAuthorizedSubject.send(false)
    }
    
    func restoreAuthorizationStatus() {
        do {
            let authorization: Authorization? = try keychain.readFromKeychain(
                keychainKey: .authorization
            )
            isAuthorizedSubject.send(authorization != nil)
        } catch {
            print("restoreAuthorizationStatus error: ", error)
        }
    }
}
