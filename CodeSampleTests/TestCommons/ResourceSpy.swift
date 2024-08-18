//
//  ResourceSpy.swift
//  CodeSampleTests
//
//  Created by Kacper Jagiełło on 18/08/2024.
//

import Foundation

@testable import CodeSample

final class ResourceSpy: Resource {
    var path: String
    var httpRequestMethod: RequestMethod
    var body: Data?
    var authorizationNeeds: AuthorizationNeeds

    init(
        path: String = "fake_path",
        httpRequestMethod: RequestMethod = .POST,
        body: Data? = nil,
        authorizationNeeds: AuthorizationNeeds = .standard
    ) {
        self.path = path
        self.httpRequestMethod = httpRequestMethod
        self.body = body
        self.authorizationNeeds = authorizationNeeds
    }
}
