//
//  KeychainManager.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/18/21.
//

import Foundation
import KeychainAccess

protocol KeychainManagerType {
    func getValue(for key: String) -> String?
    func set(value: String, for key: String)
}

final class KeychainManager: KeychainManagerType {
    static let shared = KeychainManager(server: Bundle.main.bundleIdentifier ?? Constant.baseUrl)
    
    private init(server: String) {
        keychain = Keychain(server: server,
                            protocolType: .https)
    }
    
    private let keychain: Keychain
    
    func getValue(for key: String) -> String? {
        return try? keychain.get(key)
    }
    
    func set(value: String, for key: String) {
        keychain[key] = value
    }
}
