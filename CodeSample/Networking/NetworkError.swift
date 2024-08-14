//
//  NetworkError.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import Foundation

enum NetworkError: Error {
    case failedToBuildRequest
    case invalidResponse
    case defaultError //TODO: Be more specific
}
