//
//  LoginViewModel.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import Foundation

@Observable
final class LoginViewModel {
    var username: String = ""
    var password: String = ""
    var error: Error? = nil
}
