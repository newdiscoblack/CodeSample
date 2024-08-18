//
//  NetworkClient_tests.swift
//  CodeSampleTests
//
//  Created by Kacper Jagiełło on 16/08/2024.
//

import Foundation
import Quick
import Nimble

@testable import CodeSample

class NetworkClientSpec: AsyncSpec {
    override class func spec() {
        describe("NetworkClient") {
            var sut: NetworkClient!
            var networkSession: NetworkSessionSpy!
            var requestBuilder: RequestBuilderSpy!
            var resourceSpy: ResourceSpy!
            
            beforeEach {
                networkSession = .init()
                requestBuilder = .init()
                resourceSpy = .init()
                sut = .init(
                    networkSession: networkSession,
                    requestBuilder: requestBuilder
                )
            }
            
            afterEach {
                networkSession = nil
                requestBuilder = nil
                resourceSpy = nil
                sut = nil
            }
            
            context("when request is made") {
                let expectedUrl = URL(string: "https://fake.host/fake_path")!
                
                beforeEach {
                    networkSession.dataRequestResult = (
                        Data.fixture,
                        HTTPURLResponse.fixture()
                    )
                    requestBuilder.buildUrlRequestResult = URLRequest(
                        url: expectedUrl
                    )
                    resourceSpy.body = .fixture
                    try? await sut.requestVoid(resource: resourceSpy)
                }
                
                it("will pass the correct path to the request builder") {
                    expect(requestBuilder.capturedPath)
                        .to(equal(resourceSpy.path))
                }
                
                it("will pass the correct http method to the request builder") {
                    expect(requestBuilder.capturedHttpRequestMethod)
                        .to(equal(resourceSpy.httpRequestMethod))
                }
                
                it("will pass the correct body to request builder") {
                    expect(requestBuilder.capturedBody)
                        .to(equal(resourceSpy.body))
                }
                
                it("will pass the correct authorization needs to the request builder") {
                    expect(requestBuilder.capturedAuthorizationNeeds)
                        .to(equal(resourceSpy.authorizationNeeds))
                }
                
                it("will pass the correct url to the network session") {
                    expect(networkSession.capturedRequest.url?.absoluteString)
                        .to(equal("https://fake.host/fake_path"))
                }
            }
            
            context("given the response is invalid") {
                var capturedError: Error?
                
                beforeEach {
                    networkSession.dataRequestResult = (
                        Data.fixture,
                        URLResponse(
                            url: URL.fixture,
                            mimeType: nil,
                            expectedContentLength: 0,
                            textEncodingName: nil
                        )
                    )
                    do {
                        try await sut.requestVoid(resource: resourceSpy)
                    } catch {
                        capturedError = error
                    }
                }
                
                it("will throw the invalid response error") {
                    expect(capturedError as? NetworkError)
                        .to(equal(NetworkError.invalidResponse))
                }
            }
            
            context("given the response is valid") {
                context("when status code is 2xx") {
                    let expectedData = TestData(field: "field")
                    
                    beforeEach {
                        networkSession.dataRequestResult = (
                            try! JSONEncoder().encode(expectedData),
                            HTTPURLResponse.fixture()
                        )
                    }
                    
                    it("will parse and return the data") {
                        let receivedData: TestData = try await sut.request(
                            resource: resourceSpy
                        )
                        expect(receivedData)
                            .to(equal(expectedData))
                    }
                }
                
                context("when status code is not 2xx") {
                    var capturedError: Error?
                    
                    beforeEach {
                        networkSession.dataRequestResult = (
                            Data.fixture,
                            HTTPURLResponse.fixture(statusCode: 422)
                        )
                        do {
                            try await sut.requestVoid(resource: resourceSpy)
                        } catch {
                            capturedError = error
                        }
                    }
                    
                    it("will throw the http error with correct status code") {
                        expect(capturedError as? NetworkError)
                            .to(equal(NetworkError.httpError(code: 422)))
                    }
                }
                
                context("when status code is 401") {
                    var capturedError: Error?
                    
                    beforeEach {
                        networkSession.dataRequestResult = (
                            Data.fixture,
                            HTTPURLResponse.fixture(statusCode: 401)
                        )
                        do {
                            try await sut.requestVoid(resource: resourceSpy)
                        } catch {
                            capturedError = error
                        }
                    }
                    
                    it("will throw the unauthorized request error") {
                        expect(capturedError as? NetworkError)
                            .to(equal(NetworkError.unauthorizedRequest))
                    }
                }
            }
        }
    }
}

private final class NetworkSessionSpy: NetworkSession {
    var capturedRequest: URLRequest!
    var dataRequestResult: (Data, URLResponse)!
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        capturedRequest = request
        return dataRequestResult
    }
}

private final class RequestBuilderSpy: RequestBuilding {
    var capturedPath: String?
    var capturedHttpRequestMethod: RequestMethod?
    var capturedBody: Data?
    var capturedAuthorizationNeeds: AuthorizationNeeds?
    var buildUrlRequestResult: URLRequest = URLRequest(url: URL.fixture)
    
    func buildUrlRequest<R: Resource>(
        for resource: R
    ) async throws -> URLRequest {
        capturedPath = resource.path
        capturedHttpRequestMethod = resource.httpRequestMethod
        capturedBody = resource.body
        capturedAuthorizationNeeds = resource.authorizationNeeds
        return buildUrlRequestResult
    }
}

private extension HTTPURLResponse {
    static func fixture(statusCode: Int = 200) -> HTTPURLResponse {
        HTTPURLResponse(
            url: URL.fixture,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}

private extension URL {
    static var fixture: URL {
        URL(string: "https://fixture.url.com")!
    }
}

private struct TestData: Codable, Equatable {
    let field: String
}

private extension URLRequest {
    static var fixture: URLRequest {
        URLRequest(url: .fixture)
    }
}
