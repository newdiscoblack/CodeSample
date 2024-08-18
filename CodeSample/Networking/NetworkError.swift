//
//  NetworkError.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case unauthorizedRequest
    case invalidResponse
    case httpError(code: Int)
    
    var errorDescription: String? {
        switch self {
        case .unauthorizedRequest:
            "Unauthorized request."
        case .invalidResponse:
            "Invalid response."
        case .httpError(let code):
            "HTTP Error: \(code)."
        }
    }
}
