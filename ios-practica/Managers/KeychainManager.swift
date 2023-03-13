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
    
    /*
     Pedro:
     
     Obtuve las siguientes 3 funciones de un video de YouTube. Fue más fácil para mí entender ya que las funciones tenían un valor de "retorno".
     
     Posible problema: la contraseña y el token usan el tipo de datos "data" y no la cadena. Esta podría ser la fuente de mis problemas anteriores...
     */
    
    // savePassword Opt 1, credit: https://youtu.be/cQjgBIJtMbw
    static func savePasswordInKeychain(service: String, account: String, password: Data) throws {
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
    
    
    // getPassword Opt 1, credit: https://youtu.be/cQjgBIJtMbw
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
    
    
    // ************* TOKEN *************
    
    // saveToken Opt 1, adapted directly from savePassword Opt 1
    static func saveTokenInKeychain(service: String, account: String, token: Data) throws {
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
        
        print("saveTokenInKeychain(Service: account: token:) succeeded" )
    }
    
    
    // getToken Opt 1, adapted directly from getPassword Opt 1
    static func getTokenFromKeychain(service: String, account: String) -> Data? {
        
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

    
    // saveToken Opt 1.1, removing service parameeter, ** changed token to String **
    static func saveTokenInKeychainSimple(account: String, token: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account as String,
            kSecValueData as String: token as String
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
        
        print("Service, account, & TOKEN saved successfully in KeychainSimple" )
    }
    
    
    // getToken Opt 1.1, removing service parameeter, ** changed token to String **
    static func getTokenFromKeychainSimple(account: String) -> Data? {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print("KeychainSimple token 'get' read status: \(status)")
        //print("Result = \(String(describing: result))\n")
        return result as? Data // was String
    }
    
    
    
    
    
    
    
    
    // read password Opt 2
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
            debugPrint("An error occurred while querying user information fm Keychain")
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
            print("deleteKeychainItem error\n")
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
    
    
    // saveDataBigToken using generic string "token-manager" because I might not have the user email or account to look up. Another option is to fetch user email using UserDefaults (something we are not supposed to do in this case)
    func saveDataBigToken(token: String) {
        
        // definimos un usuario
        let username = "token-manager"
        let token = token
        
        // Preparamos los atributos necesarios
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: token
        ]

        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            debugPrint("User info saved successfully")
        } else {
            debugPrint("Error saving user info")
        }
        
    }
    
    // readDataBigToken using generic string "token-manager" because I might not have the user email or account to look up. Another option is to fetch user email using UserDefaults (something we are not supposed to do in this case)
    func readDataBigToken(username: String) {
        
        let username = "token-manager"
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            
            if let existingItem = item as? [String: Any],
               let username = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: .utf8) {
                
                debugPrint("La info es: \(username) - \(password)")
            }
        } else {
            debugPrint("An error occurred while querying user information fm Keychain")
        }
    }
    
}
