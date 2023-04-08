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
            debugPrint("Token deleted from Keychain successfully\n")
        } else {
            debugPrint("deleteKeychainItem error\n")
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
            debugPrint("Token saved to Keychain successfully. Token = \(token)\n")
        } else {
            debugPrint("Error saving user info")
        }
        
    }
    
    static func getTokenFmKC() -> String? {
        
        if Global.tokenMaster.isEmpty {
            print("tokenMaster is empty\n")
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
                
                debugPrint("Reading token fm Keychain: \(token)")
                Global.tokenMaster = token
                return token
            }
        }
        
        debugPrint("An error occurred while querying user information fm Keychain")
        return ""
    }
    
}
