//
//  AuthorizerSpy.swift
//  CodeSampleTests
//
//  Created by Kacper Jagiełło on 19/08/2024.
//

import Combine

@testable import CodeSample

final class AuthorizerSpy: Authorizing {
    var isAuthorizedSubject = CurrentValueSubject<Bool, Never>(false)
    var isAuthorized: AnyPublisher<Bool, Never> {
        isAuthorizedSubject.eraseToAnyPublisher()
    }
    
    var restoreAuthorizationStatusCallsCount = 0
    func restoreAuthorizationStatus() {
        restoreAuthorizationStatusCallsCount += 1
    }
    
    var logInWithCapturedUsername: String?
    var logInWithCapturedPassword: String?
    var logInWithThrowableError: Error?
    func logInWith(
        username: String,
        password: String
    ) async throws {
        logInWithCapturedUsername = username
        logInWithCapturedPassword = password
        if let logInWithThrowableError {
            throw logInWithThrowableError
        }
    }
    
    var logOutCallsCount = 0
    func logOut() {
        logOutCallsCount += 1
    }
}
