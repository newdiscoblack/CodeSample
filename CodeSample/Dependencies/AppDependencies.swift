//
//  AppDependencies.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

final class AppDependencies {
    lazy var keychain = Keychain()
    lazy var requestBuilder = RequestBuilder(
        host: "https://playground.nordsec.com",
        keychain: keychain
    )
    lazy var networkClient = NetworkClient(
        requestBuilder: requestBuilder
    )
    lazy var authorizer = Authorizer(
        loginService: networkClient,
        keychain: keychain
    )
}
