//
//  LocalDataLayer.swift
//  ios-practica
//
//  Created by Eric Olsson on 12/29/22.
//  Tokenize & persist login // complete ✅

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
    }
    
    func saveEmailToUserDefaults(email: String) {
        return UserDefaults.standard.set(email, forKey: Self.email)
    }

    func getTokenFmUserDefaults() -> String {
        return UserDefaults.standard.string(forKey: Self.token) ?? ""
    }
    // Used in: HerosListViewVC, fetches token for api call, get heros
        
//    func getTokenFmKeychain() {//}-> String { // purpose:
//        return keychain.readData(service: "", account: <#T##String#>) //?? "" // Data("ejolsson@gmail".utf8)
//        return keychain.readData(service: <#T##String#>, account: )
//        return LoginViewController.getToken(<#T##self: LoginViewController##LoginViewController#>)
//    }
    // Used in: HerosListViewVC — NOT YET!!! ⚠️
    // Purpose: Fetch & prep token for api call, get heros
    // Observations: putting any email in "" after the ?? seems to enable login persistence after rerunning. ANS: See func isUserLoggedIn()... IF "not empty", THEN show HerosListViewVC
    
    func isUserLoggedIn() -> Bool {
        return !getTokenFmUserDefaults().isEmpty
//        return !login.getToken(account: )
    }


    func saveHerosToUserDefaults(heros: [HeroModel]) {
        if let encodedHeros = try? JSONEncoder().encode(heros) {
            UserDefaults.standard.set(encodedHeros, forKey: Self.heros)
        }
    } // this is the magic save func for UserDefaults
    

    
    func getHeros() -> [HeroModel] {
        if let savedHerosData = UserDefaults.standard.object(forKey: Self.heros) as? Data {
            do {
                let savedHeros = try JSONDecoder().decode([HeroModel].self, from: savedHerosData)
                return savedHeros
            } catch {
                print("Error occurred")
                return []
            }
        } else {
            return []
        }
    } // Oscar func, uses Hero, not used as of 2/25 commit
    
//    func getHeros2() {
//        let hero = HeroCD(context: context)
//        
//        hero.id = id
//        hero.name = name
//    }
}
