//
//  XCTestCase+firstElement.swift
//  CodeSampleTests
//
//  Created by Kacper Jagiełło on 18/08/2024.
//

import Combine
import Foundation
import XCTest

public extension XCTestCase {
    @discardableResult
    func firstElement<P>(
        from publisher: P,
        timeout: TimeInterval = 0.02,
        afterAction action: (() async throws -> Void)? = nil,
        storingIn cancellables: inout Set<AnyCancellable>,
        file: StaticString = #file,
        line: UInt = #line
    ) async throws -> P.Output
    where P: Publisher {
        let value = try await self.awaitEmission(
            from: publisher,
            timeout: timeout,
            afterAction: action,
            storingIn: &cancellables
        ).get()
        return value
    }
    
    private struct AwaitError: Error {}
    private func awaitEmission<P>(
        from publisher: P,
        timeout: TimeInterval = 0.02,
        afterAction action: (() async throws -> Void)? = nil,
        storingIn cancellables: inout Set<AnyCancellable>
    ) async throws -> Result<P.Output, P.Failure>
    where P: Publisher {
        var result: Result<P.Output, P.Failure>?
        let didEmit = expectation(description: "Did emit event")

        publisher
            .prefix(1)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        result = .failure(error)
                    }
                    didEmit.fulfill()
                },
                receiveValue: { value in
                    result = .success(value)
                }
            )
            .store(in: &cancellables)

        try await action?()
        await fulfillment(of: [didEmit], timeout: timeout)
        guard let unwrappedResult = result else { throw AwaitError() }
        return unwrappedResult
    }
}

