//
//  Keychain.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import Foundation
import Valet

protocol KeychainStoring {
    func saveInKeychain<T: Encodable>(
        _ item: T, keychainKey: KeychainKey
    ) throws
    func readFromKeychain<T: Decodable>(
        keychainKey: KeychainKey
    ) throws -> T?
    func clear(_ keychainKey: KeychainKey)
}

enum KeychainKey: String {
    case authorization
}

final class Keychain: KeychainStoring {
    private let appValet: Valet
    
    init() {
        appValet = .valet(
            with: Identifier(nonEmpty: "CodeSample")!,
            accessibility: .afterFirstUnlock
        )
    }
    
    func saveInKeychain<T>(
        _ item: T,
        keychainKey: KeychainKey
    ) throws where T : Encodable {
        switch keychainKey {
        case .authorization:
            appValet.store(value: item, forKey: keychainKey)
        }
    }
    
    func readFromKeychain<T>(
        keychainKey: KeychainKey
    ) throws -> T? where T : Decodable {
        switch keychainKey {
        case .authorization:
            return try appValet.read(atKey: keychainKey)
        }
    }
    
    func clear(_ keychainKey: KeychainKey) {
        try? appValet.removeObject(forKey: keychainKey.rawValue)
    }
    
}

private extension Valet {
    func store<T: Encodable>(value: T, forKey key: KeychainKey) {
        do {
            let data = try JSONEncoder.toSnakeCase.encode(value)
            try setObject(data, forKey: key.rawValue)
        } catch {
            assertionFailure(
                "Failed to encode value: \(value): error: \(error.localizedDescription)"
            )
        }
    }
    
    func read<T: Decodable>(atKey key: KeychainKey) throws -> T? {
        guard let data = try? object(forKey: key.rawValue) else { return nil }
        return try JSONDecoder.fromSnakeCase.decode(T.self, from: data)
    }
}
