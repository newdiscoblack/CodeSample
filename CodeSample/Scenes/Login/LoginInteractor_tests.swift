//
//  LoginInteractor_tests.swift
//  CodeSampleTests
//
//  Created by Kacper Jagiełło on 19/08/2024.
//

import Combine
import Foundation
import Quick
import Nimble

@testable import CodeSample

class LoginInteractorSpec: AsyncSpec {
    override class func spec() {
        describe("LoginInteractor") {
            var sut: LoginInteractor!
            var authorizer: AuthorizerSpy!
            var viewModel: LoginViewModel!
            
            beforeEach {
                authorizer = .init()
                viewModel = .init()
                sut = .init(
                    authorizer: authorizer,
                    viewModel: viewModel
                )
            }
            
            afterEach {
                authorizer = nil
                viewModel = nil
                sut = nil
            }
            
            context("given there are no errors") {
                context("when logging in") {
                    let expectedUsername = "test_username"
                    let expectedPassword = "test_password"
                    
                    beforeEach {
                        viewModel.username = expectedUsername
                        viewModel.password = expectedPassword
                        await sut.logIn()
                    }
                    
                    it("will log in using correct username") {
                        expect(authorizer.logInWithCapturedUsername)
                            .to(equal(expectedUsername))
                    }
                    
                    it("will log in using correct password") {
                        expect(authorizer.logInWithCapturedPassword)
                            .to(equal(expectedPassword))
                    }
                }
            }
            
            context("given there is an error") {
                context("when logging in") {
                    struct LogInError: Error, Equatable {}
                    let expectedError = LogInError()
                    
                    beforeEach {
                        authorizer.logInWithThrowableError = expectedError
                        await sut.logIn()
                    }
                    
                    it("will present an error") {
                        expect(viewModel.error)
                            .to(matchByDescription(expectedError))
                    }
                }
            }
        }
    }
}

private final class AuthorizerSpy: Authorizing {
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

private func matchByDescription<T>(_ expectedValue: T?) -> Matcher<T> {
    return Matcher.define { actualExpression, message in
        let receivedValue = try actualExpression.evaluate()
        switch (receivedValue, expectedValue) {
        case let (receivedValue?, expectedValue?):
            let receivedValueString = String(describing: receivedValue)
            let expectedValueString = String(describing: expectedValue)
            return MatcherResult(
                bool: receivedValueString == expectedValueString,
                message: ExpectationMessage.expectedCustomValueTo(
                    expectedValueString,
                    actual: receivedValueString
                )
            )
        case let (nil, expectedValue?):
            let message = ExpectationMessage.expectedCustomValueTo(
                "equal <\(expectedValue)>",
                actual: "nil"
            )
            return MatcherResult(status: .fail, message: message)
        case (_?, nil):
            return MatcherResult(status: .fail, message: ExpectationMessage.fail("").appendedBeNilHint())
        case (nil, nil):
            return MatcherResult(status: .matches, message: message)
        }
    }
}
