//
//  AppDependencies.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

final class AppDependencies {
    let appDatabaseService = AppDatabaseService()
    let keychain = Keychain()
    lazy var requestBuilder = RequestBuilder(
        host: "https://playground.nordsec.com",
        authorizationProvider: keychain
    )
    lazy var networkClient = NetworkClient(
        requestBuilder: requestBuilder
    )
    lazy var authorizer = Authorizer(
        loginService: networkClient,
        keychain: keychain
    )
}
