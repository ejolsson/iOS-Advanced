//
//  KeyChainManager.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/16/23.
//

import UIKit
import Security

class KeychainManager {
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown (OSStatus)
    }

    static func deleteTokenFmKC() {
       
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "token-keeper"
        ]
        
        if (SecItemDelete(query as CFDictionary)) == noErr {
            print("Token deleted from Keychain successfully\n")
        } else {
            print("deleteKeychainItem error\n")
        }
    }
    
    static func saveTokenInKC(token: String) {
        
        let token = token

        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "token-keeper",
            kSecValueData as String: token.data(using: .utf8)!
        ]

        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            print("Token saved to Keychain successfully. Token = \(token)\n")
        } else {
            print("Error saving user info")
        }
        
    }
    
    static func getTokenFmKC() -> String? {
        
        if Global.token.isEmpty {
            print("Global.token is empty\n")
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "token-keeper",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            
            if let existingItem = item as? [String: Any],

               let tokenData = existingItem[kSecValueData as String] as? Data,
               let token = String(data: tokenData, encoding: .utf8) {
                
                print("Reading token fm Keychain: \(token)")
                Global.token = token
                return token
            }
        }
        
        print("An error occurred while querying user information fm Keychain")
        return ""
    }
    
}
