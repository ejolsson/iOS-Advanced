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
    func save(token: String) {
        return UserDefaults.standard.set(token, forKey: Self.token)
    } // user token is saved to user defaults
    
    // TODO: - Replace UserDefaults with Core Data
    func getToken() -> String {
        return UserDefaults.standard.string(forKey: Self.token) ?? ""
    }
    // Used in: HerosListViewVC
    // Purpose: Fetch & prep token for api call, get heros
    // Impleme: Reads value fm UserDefaults
    // Status: Works
    
    func getToken2() -> String { // purpose:
        return keychain.readData(email: "") ?? "" // Data("ejolsson@gmail".utf8)
    }
    // Used in: HerosListViewVC — NOT YET!!! ⚠️
    // Purpose: Fetch & prep token for api call, get heros
    // Observations: putting any email in "" after the ?? seems to enable login persistence after rerunning. ANS: See func isUserLoggedIn()... IF "not empty", THEN show HerosListViewVC
    
    func isUserLoggedIn() -> Bool {
        return !getToken().isEmpty
    } // complete

    func isUserLoggedIn2() -> Bool {
        return !getToken2().isEmpty
    }
    // Used in: SceneDelegate
    // Purpose: IF stmt → choose HeroListVC or LoginVC
    // uses keychain storage

    func save(heros: [Hero]) {
        if let encodedHeros = try? JSONEncoder().encode(heros) {
            UserDefaults.standard.set(encodedHeros, forKey: Self.heros)
        }
    } // complete
    
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
}
