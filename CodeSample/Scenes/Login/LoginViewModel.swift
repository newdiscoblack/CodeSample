//
//  LoginViewModel.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var username: String = "tesonet"
    @Published var password: String = "partyanimal"
    @Published var error: Error? = nil
}
