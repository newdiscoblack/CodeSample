//
//  NetworkError.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import Foundation

enum NetworkError: LocalizedError {
    case unauthorizedRequest
    case failedToBuildRequest
    case invalidResponse
    case httpError(code: Int) //TODO: Be more specific
    
    var errorDescription: String? {
        switch self {
        case .unauthorizedRequest:
            "Unauthorized request."
        case .failedToBuildRequest:
            "Failed to build the request."
        case .invalidResponse:
            "Invalid response."
        case .httpError(let code):
            "HTTP Error: \(code)."
        }
    }
}
