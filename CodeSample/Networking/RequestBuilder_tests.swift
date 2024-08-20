//
//  RequestBuilder_tests.swift
//  CodeSampleTests
//
//  Created by Kacper Jagiełło on 18/08/2024.
//

import Foundation
import Quick
import Nimble

@testable import CodeSample

class RequestBuilderSpec: AsyncSpec {
    override class func spec() {
        describe("RequestBuilder") {
            var sut: RequestBuilder!
            var authorizationProvider: AuthorizationProviderSpy!
            
            beforeEach {
                authorizationProvider = .init()
                sut = .init(
                    host: "https://fake.host",
                    authorizationProvider: authorizationProvider
                )
            }
            
            afterEach {
                authorizationProvider = nil
                sut = nil
            }
            
            context("given the resource is valid") {
                var expectedUrlRequest: URLRequest?
                
                beforeEach {
                    let resource = ResourceSpy(
                        path: "fake/path",
                        httpRequestMethod: .GET,
                        authorizationNeeds: .none
                    )
                    
                    expectedUrlRequest = try? await sut.buildUrlRequest(
                        for: resource
                    )
                }
                
                it("will build a valid url") {
                    await expect(expectedUrlRequest?.url?.absoluteString)
                        .toEventually(equal("https://fake.host/fake/path"))
                }
                
                it("will set the correct http method") {
                    await expect(expectedUrlRequest?.httpMethod)
                        .toEventually(equal("GET"))
                }
                
                it("will set the correct body") {
                    await expect(expectedUrlRequest?.httpBody)
                        .toEventually(beNil())
                }
            }
            
            context("given the resource has a body") {
                var expectedUrlRequest: URLRequest?
                let expectedBody = Data.fixture
                
                beforeEach {
                    let resource = ResourceSpy(
                        path: "fake/path",
                        httpRequestMethod: .GET,
                        body: expectedBody,
                        authorizationNeeds: .none
                    )
                    
                    expectedUrlRequest = try? await sut.buildUrlRequest(
                        for: resource
                    )
                }
                
                it("will set the correct body") {
                    await expect(expectedUrlRequest?.httpBody)
                        .toEventually(equal(expectedBody))
                }
                
                it("will add the correct Content-Type header") {
                    await expect(expectedUrlRequest?.allHTTPHeaderFields!["Content-Type"])
                        .toEventually(equal("application/json"))
                }
            }
            
            context("given the resource does not need authorization") {
                var expectedUrlRequest: URLRequest?
                
                beforeEach {
                    let resource = ResourceSpy(
                        path: "fake/path",
                        httpRequestMethod: .GET,
                        authorizationNeeds: .none
                    )
                    
                    expectedUrlRequest = try? await sut.buildUrlRequest(
                        for: resource
                    )
                }
                
                it("will not call authorization provider for authorization") {
                    await expect(authorizationProvider.getStandardAuthorizationTokenCallsCount)
                        .toEventually(equal(0))
                }
                
                it("will not try to authorize the request") {
                    await expect(expectedUrlRequest?.allHTTPHeaderFields!["Authorization"])
                        .toEventually(beNil())
                }
            }
            
            context("given the resource needs authorization") {
                var expectedUrlRequest: URLRequest?
                
                beforeEach {
                    authorizationProvider.getStandardAuthorizationTokenReturnValue = "test_token"
                    let resource = ResourceSpy(
                        path: "fake/path",
                        httpRequestMethod: .GET,
                        authorizationNeeds: .standard
                    )
                    
                    expectedUrlRequest = try? await sut.buildUrlRequest(
                        for: resource
                    )
                }
                
                it("will call authorization provider for authorization") {
                    await expect(authorizationProvider.getStandardAuthorizationTokenCallsCount)
                        .toEventually(equal(1))
                }
                
                it("will authorize the request using the correct token") {
                    await expect(expectedUrlRequest?.allHTTPHeaderFields!["Authorization"])
                        .toEventually(equal("Bearer test_token"))
                }
            }
        }
    }
}

private final class AuthorizationProviderSpy: AuthorizationProviding {
    var getStandardAuthorizationTokenCallsCount = 0
    var getStandardAuthorizationTokenReturnValue: String?
    func getStandardAuthorizationToken() -> String? {
        getStandardAuthorizationTokenCallsCount += 1
        return getStandardAuthorizationTokenReturnValue
    }
}
