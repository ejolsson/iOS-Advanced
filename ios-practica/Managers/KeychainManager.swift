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

class KeychainManager {
    enum KeychainError: Error {
        case duplicateEntry
        case unknown (OSStatus)
    }
    
    static func savePasswordInKeychain(
        service: String,
        account: String,
        password: Data
    ) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject,
        ]
        
        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown (status)
        }
        
        print("Service, account, & PASSWORD saved successfully in Keychain" )
    }
    
    static func getPasswordFromKeychain(service: String, account: String) -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print("Keychain password 'get' read status: \(status)")
        return result as? Data
    }
    
    static func saveTokenInKeychain(
        service: String,
        account: String,
        token: Data // was type "data"
    ) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: token as AnyObject,
        ]
        
        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown (status)
        }
        
        print("Service, account, & TOKEN saved successfully in Keychain" )
    }
    
    static func getTokenFromKeychain(service: String, account: String) -> Data? { // was -> Data?
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print("Keychain token 'get' read status: \(status)")
        //print("Result = \(String(describing: result))\n")
        return result as? Data // was String
    }
    
    func readData(service: String, account: String) { // Pedro
        
        // Preparamos la consulta
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: service,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            
            // extraemos la información
            if let existingItem = item as? [String: Any],
               let username = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: .utf8) {
            
                debugPrint("La info es: \(username) - \(password)")
            }
            
        } else {
            debugPrint("Se produjo un error al consultar la información del usuario")
        }
        
    } // Pedro
    
    static func deleteKeychainItem(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]
        
        if (SecItemDelete(query as CFDictionary)) == noErr {
            print("User info deleted successfully\n")
        } else {
            print("Deletion error\n")
        }
    }
    
    static func saveLoginStatusInKeychain(
        service: String,
//        account: String,
        loginStatus: Bool
    ) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
//            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: loginStatus as AnyObject,
        ]
        
        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )
        
//        guard status != errSecDuplicateItem else {
//            throw KeychainError.duplicateEntry
//        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown (status)
        }
        
        print("Login status saved successfully in Keychain" )
    }
}


// Credit: https://youtu.be/cQjgBIJtMbw

//class KeychainManager {
//
//    func saveData(email: String, token: String) { // remove password: String,
//
//        //let token = UserDefaults.standard.string(forKey: LocalDataLayer.token)
//        print("Preparing to saveData into keychain\n")
//        print("email = \(email)\n")
//        print("token = \(token)\n")
//
//        print("Reading fm UserDefaults: \(UserDefaults.standard.string(forKey: "token"))\n")
//
//        let attributes: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrAccount as String: email,
//            //kSecValueData as String: password,
//            kSecValueData as String: token
//        ]
//
//        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
//            debugPrint("User information saved successfully into Keychain")
//        } else {
//            debugPrint("Error saving user info into Keychain")
//        }
//    }
//
////    func readData(email: String) -> String?
//    func readData() {//}-> String? { // email: Data or String???
//
//        // Prep query
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
////            kSecAttrAccount as String: email,
//            kSecMatchLimit as String: kSecMatchLimitOne,
//            kSecReturnAttributes as String: true,
//            kSecReturnData as String: true
//        ]
//
//        var item: CFTypeRef?
//
//        //var result: String? //AnyObject?
//
//        let status = SecItemCopyMatching(query as CFDictionary, &item)
//
//        print("Keychain readData status: \(status)")
////        print("Email read fm keychain: \(email)")
//        //print("Token read fm keychain: \(token)")
//        //return result //as? Data
//
//
//        // extract info // KEEPCODING METHOD
//        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
//
//            if let existingItem = item as? [String: Any],
//               let email = existingItem[kSecAttrAccount as String] as? String,
//               let tokenData = existingItem[kSecValueData as String] as? Data,
//               let token = String(data: tokenData, encoding: .utf8) {
//
//                debugPrint("The info is: \(email) - \(token)")
//                //return token
//            }
//
//        } else {
//            debugPrint("A username error was produced")
//            //return nil
//        }
////        return token
//    }
//
//    static func get(email: String) -> Data? {
//        let query: [String: AnyObject] = [
//            kSecClass as String: kSecClassGenericPassword,
//            //kSecAttrService as String: service as AnyObject,
//            kSecAttrAccount as String: email as AnyObject,
//            kSecReturnData as String: kCFBooleanTrue,
//            kSecMatchLimit as String: kSecMatchLimitOne
//        ]
//
//        var result: AnyObject?
//        let status = SecItemCopyMatching(query as CFDictionary, &result)
//
//        print("Read status: \(status)")
//        return result as? Data
//    }
//
//    func updateData() {
//    }
//
//    func deleteData() {
//    }
//
//} // old version

