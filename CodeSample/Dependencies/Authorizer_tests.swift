//
//  Authorizer_tests.swift
//  CodeSampleTests
//
//  Created by Kacper Jagiełło on 18/08/2024.
//

import Combine
import Foundation
import Quick
import Nimble

@testable import CodeSample

class AuthorizerSpec: AsyncSpec {
    override class func spec() {
        describe("Authorizer") {
            var sut: Authorizer!
            var loginService: LoginServiceSpy!
            var keychain: KeychainSpy!
            var cancellables: Set<AnyCancellable>!
            
            beforeEach {
                loginService = .init()
                keychain = .init()
                sut = .init(
                    loginService: loginService,
                    keychain: keychain
                )
                cancellables = .init()
            }
            
            afterEach {
                cancellables = nil
                keychain = nil
                loginService = nil
                sut = nil
            }
            
            context("given there is no stored authorization") {
                var expectedEmittedValue: Bool?
                
                context("when restoring authorization") {
                    beforeEach {
                        sut.restoreAuthorizationStatus()
                        expectedEmittedValue = try await currentSpec()?
                            .firstElement(
                                from: sut.isAuthorized,
                                timeout: 1,
                                afterAction: { sut.restoreAuthorizationStatus() },
                                storingIn: &cancellables
                            )
                    }
                    
                    it("will look for stored authorization") {
                        expect(keychain.readFromKeychainCapturedKeychainKey)
                            .to(equal(.authorization))
                    }
                    
                    it("will not restore authorization") {
                        await expect(expectedEmittedValue)
                            .toEventually(beFalse())
                    }
                }
            }
            
            context("given there is a stored authorization") {
                var emittedAuthorizationStatus: Bool?
                
                context("when restoring authorization") {
                    beforeEach {
                        keychain.store_authorization(
                            .init(token: "stored_authorization")
                        )
                        sut.restoreAuthorizationStatus()
                        emittedAuthorizationStatus = try await currentSpec()?
                            .firstElement(
                                from: sut.isAuthorized,
                                timeout: 1,
                                afterAction: { sut.restoreAuthorizationStatus() },
                                storingIn: &cancellables
                            )
                    }
                    
                    it("will look for stored authorization") {
                        expect(keychain.readFromKeychainCapturedKeychainKey)
                            .to(equal(.authorization))
                    }
                    
                    it("will restore authorization") {
                        await expect(emittedAuthorizationStatus)
                            .toEventually(beTrue())
                    }
                }
            }
            
            context("when logging in") {
                let expectedUsername = "test_user"
                let expectedPassword = "test_password"
                let expectedAuthorization = Authorization.init(token: "test_token")
                var emittedAuthorizationStatus: Bool?
                
                beforeEach {
                    loginService.logInWithReturnValue = expectedAuthorization
                    try? await sut.logInWith(
                        username: expectedUsername,
                        password: expectedPassword
                    )
                    emittedAuthorizationStatus = try await currentSpec()?
                        .firstElement(
                            from: sut.isAuthorized,
                            timeout: 1,
                            afterAction: { sut.restoreAuthorizationStatus() },
                            storingIn: &cancellables
                        )
                }
                
                it("will use provided username") {
                    await expect(loginService.logInWithCapturedUsername)
                        .toEventually(equal(expectedUsername))
                }
                
                it("will use provided password") {
                    await expect(loginService.logInWithCapturedPassword)
                        .toEventually(equal(expectedPassword))
                }
                
                it("will store the received authorization") {
                    await expect(keychain.saveInKeychainCapturedValue as? Authorization)
                        .toEventually(equal(expectedAuthorization))
                }
                
                it("will store the received authorization with the correct key") {
                    await expect(keychain.saveInKeychainCapturedKeychainKey)
                        .toEventually(equal(.authorization))
                }
                
                it("will update the authorization status correctly") {
                    await expect(emittedAuthorizationStatus)
                        .toEventually(beTrue())
                }
            }
            
            context("when logging out") {
                var emittedAuthorizationStatus: Bool?
                
                beforeEach {
                    sut.logOut()
                    emittedAuthorizationStatus = try await currentSpec()?
                        .firstElement(
                            from: sut.isAuthorized,
                            timeout: 1,
                            afterAction: { sut.restoreAuthorizationStatus() },
                            storingIn: &cancellables
                        )
                }
                
                it("will clear authorization in the keychain") {
                    expect(keychain.clearCapturedKeychainKey)
                        .to(equal(.authorization))
                }
                
                it("will update the authorization status correctly") {
                    await expect(emittedAuthorizationStatus)
                        .toEventually(beFalse())
                }
            }
        }
    }
}

private final class LoginServiceSpy: LoginServing {
    var logInWithCapturedUsername: String?
    var logInWithCapturedPassword: String?
    var logInWithReturnValue: Authorization!
    func logInWith(
        username: String,
        password: String
    ) async throws -> Authorization {
        logInWithCapturedUsername = username
        logInWithCapturedPassword = password
        return logInWithReturnValue
    }
}

private final class KeychainSpy: KeychainStoring {
    var saveInKeychainCapturedValue: Encodable?
    var saveInKeychainCapturedKeychainKey: KeychainKey?
    func saveInKeychain<T: Encodable>(
        _ item: T,
        keychainKey: KeychainKey
    ) throws {
        saveInKeychainCapturedValue = item
        saveInKeychainCapturedKeychainKey = keychainKey
    }
    
    var readFromKeychainCallsCount: Int = 0
    var readFromKeychainCapturedKeychainKey: KeychainKey?
    func readFromKeychain<T: Decodable>(
        keychainKey: KeychainKey
    ) throws -> T? {
        readFromKeychainCallsCount += 1
        readFromKeychainCapturedKeychainKey = keychainKey
        guard let data = testAuthorizationData else { return nil }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    private var testAuthorizationData: Data?
    func store_authorization(_ authorization: Authorization?) {
        testAuthorizationData = try! JSONEncoder().encode(authorization)
    }
    
    var clearCallsCount = 0
    var clearCapturedKeychainKey: KeychainKey?
    func clear(_ keychainKey: KeychainKey) {
        clearCallsCount += 1
        clearCapturedKeychainKey = keychainKey
    }
}
