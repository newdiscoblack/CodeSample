//
//  RequestBuilderError.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 16/08/2024.
//

import Foundation

enum RequestBuilderError: Error {
    case failedToBuildTheRequest
    case failedToAuthorizeTheRequest
}
