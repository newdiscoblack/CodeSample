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
                        await expect(authorizer.logInWithCapturedUsername)
                            .toEventually(equal(expectedUsername))
                    }
                    
                    it("will log in using correct password") {
                        await expect(authorizer.logInWithCapturedPassword)
                            .toEventually(equal(expectedPassword))
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
                    
                    it("will present the error") {
                        await expect(viewModel.error)
                            .toEventually(matchByDescription(expectedError))
                    }
                }
            }
        }
    }
}
