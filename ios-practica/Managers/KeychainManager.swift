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


// PUT KEYCHAIN LOGIC IN LOCAL DATA LAYER

// Credit: https://youtu.be/cQjgBIJtMbw

class KeychainManager {
    
    func saveData(email: String, token: String) { // remove password: String,

        //let token = UserDefaults.standard.string(forKey: LocalDataLayer.token)
        print("Preparing to saveData into keychain\n")
        print("email = \(email)\n")
        print("token = \(token)\n")
        
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            //kSecValueData as String: password,
            kSecValueData as String: token
        ]
        
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            debugPrint("User information saved successfully into Keychain")
        } else {
            debugPrint("Error saving user info into Keychain")
        }
    }
    
    func readData(email: String) -> String? { // email: Data or String???
        
        // Prep query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        
        var result: String? //AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        print("Read status: \(status)")
        return result //as? Data
        
        
        // extract info // KEEPCODING METHOD
//        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
//
//            if let existingItem = item as? [String: Any],
//               let email = existingItem[kSecAttrAccount as String] as? String,
//               let tokenData = existingItem[kSecValueData as String] as? Data,
//               let token = String(data: tokenData, encoding: .utf8) {
//
//                debugPrint("The info is: \(email) - \(token)")
//                return token
//            }
//
//        } else {
//            debugPrint("A username error was produced")
//            return nil
//        }
//        return token
    }
    
    static func get(email: String) -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            //kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: email as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print("Read status: \(status)")
        return result as? Data
    }
    
    func updateData() {
    }
    
    func deleteData() {
    }
    
}

