//
//  KeyChainManager.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/16/23.
//

import UIKit
import Security

// https://developer.apple.com/documentation/security/keychain_services/
// https://stackoverflow.com/questions/68209016/store-accesstoken-in-ios-keychain
// https://developer.apple.com/documentation/security/ksecattrtokenid

class KeychainManager {
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown (OSStatus)
    }

    
    static func deleteBigToken() {
       
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
    
//    static func saveLoginStatusInKeychain(
//        service: String,
////        account: String,
//        loginStatus: Bool
//    ) throws {
//        let query: [String: AnyObject] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrService as String: service as AnyObject,
////            kSecAttrAccount as String: account as AnyObject,
//            kSecValueData as String: loginStatus as AnyObject,
//        ]
//
//        let status = SecItemAdd(
//            query as CFDictionary,
//            nil
//        )
//
////        guard status != errSecDuplicateItem else {
////            throw KeychainError.duplicateEntry
////        }
//
//        guard status == errSecSuccess else {
//            throw KeychainError.unknown (status)
//        }
//
//        print("Login status saved successfully in Keychain" )
//    }
    
    static func saveDataBigToken(token: String) {
        
        let token = token

        // Preparamos los atributos necesarios
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
    
    static func readBigToken() -> String? {
        
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
//               let key = existingItem[kSecAttrAccount as String] as? String, //Immutable value 'kev' was never used: consider replacing with ' ' or removing it
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
