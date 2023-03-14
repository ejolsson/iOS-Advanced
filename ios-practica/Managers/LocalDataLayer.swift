//
//  LocalDataLayer.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/11/23.
//  

import Foundation

final class LocalDataLayer {
    
    private static let token = "token"
    private static let email = "email"
    private static let heros = "heros"
    
    static let shared = LocalDataLayer()
    let keychain = KeychainManager()
    let login = LoginViewController()
    
    func saveTokenToUserDefaults(token: String) {
        return UserDefaults.standard.set(token, forKey: Self.token)
    } // used in LoginViewController.swift Ln 43
    
    func saveEmailToUserDefaults(email: String) {
        return UserDefaults.standard.set(email, forKey: Self.email)
    } // used in LoginViewController.swift Ln 42

    func getTokenFmUserDefaults() -> String {
        return UserDefaults.standard.string(forKey: Self.token) ?? ""
    }
        
    // TODO: - create getTokenFmKeychain function to replace getTokenFmUserDefaults()
//    func getTokenFmKeychain() {//}-> String { // purpose:
//        return keychain.readData(service: "", account: <#T##String#>) //?? "" // Data("ejolsson@gmail".utf8)
//        return keychain.readData(service: <#T##String#>, account: )
//        return LoginViewController.getToken(<#T##self: LoginViewController##LoginViewController#>)
//    }

    
    func isUserLoggedIn() -> Bool {
        return !getTokenFmUserDefaults().isEmpty
    }


    func saveHerosToUserDefaults(heros: [HeroModel]) {
        if let encodedHeros = try? JSONEncoder().encode(heros) {
            UserDefaults.standard.set(encodedHeros, forKey: Self.heros)
        }
    } // used for UserDefaults, need to move away from this

    // BELOW NOT USED!!!
    
//    func getHeros() -> [HeroModel] {
//        if let savedHerosData = UserDefaults.standard.object(forKey: Self.heros) as? Data {
//            do {
//                let savedHeros = try JSONDecoder().decode([HeroModel].self, from: savedHerosData)
//                return savedHeros
//            } catch {
//                print("Error occurred")
//                return []
//            }
//        } else {
//            return []
//        }
//    } // not used
 
   }
