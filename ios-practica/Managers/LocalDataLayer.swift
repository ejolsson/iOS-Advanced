//
//  LocalDataLayer.swift
//  ios-practica
//
//  Created by Eric Olsson on 12/29/22.
//  Tokenize & persist login // complete ✅

import Foundation

final class LocalDataLayer {
    
    private static let token = "token"
    private static let heros = "heros"
    
    static let shared = LocalDataLayer()
    let keychain = KeychainManager()
    
    // TODO: - Replace UserDefaults with Core Data
    func saveTokenToUserDefaults(token: String) {
        return UserDefaults.standard.set(token, forKey: Self.token)
    } // user token is saved to user defaults
    
    // TODO: - Replace UserDefaults with Core Data
    func getTokenFmUserDefaults() -> String {
        return UserDefaults.standard.string(forKey: Self.token) ?? ""
    }
    // Used in: HerosListViewVC
    // Purpose: Fetch & prep token for api call, get heros
    // Impleme: Reads value fm UserDefaults
    // Status: Works
    
    func getTokenFmKeychain() {//}-> String { // purpose:
        return keychain.readData() //?? "" // Data("ejolsson@gmail".utf8)
    }
    // Used in: HerosListViewVC — NOT YET!!! ⚠️
    // Purpose: Fetch & prep token for api call, get heros
    // Observations: putting any email in "" after the ?? seems to enable login persistence after rerunning. ANS: See func isUserLoggedIn()... IF "not empty", THEN show HerosListViewVC
    
    func isUserLoggedIn() -> Bool {
        return !getTokenFmUserDefaults().isEmpty
    } // complete

//    func isUserLoggedIn2() -> Bool {
//        return !getToken2().isEmpty
//    }
    // Used in: SceneDelegate
    // Purpose: IF stmt → choose HeroListVC or LoginVC
    // uses keychain storage

    func saveHerosToUserDefaults(heros: [Hero]) {
        if let encodedHeros = try? JSONEncoder().encode(heros) {
            UserDefaults.standard.set(encodedHeros, forKey: Self.heros)
        }
    } // this is the magic save func for UserDefaults
    

    
    func getHeros() -> [Hero] {
        if let savedHerosData = UserDefaults.standard.object(forKey: Self.heros) as? Data {
            do {
                let savedHeros = try JSONDecoder().decode([Hero].self, from: savedHerosData)
                return savedHeros
            } catch {
                print("Error occurred")
                return []
            }
        } else {
            return []
        }
    } // complete
    
//    func getHeros2() {
//        let hero = HeroCD(context: context)
//        
//        hero.id = id
//        hero.name = name
//    }
}
