//
//  LoginViewModel.swift
//  ios-practica
//
//  Created by Eric Olsson on 3/21/23.
//

import Foundation
import UIKit

class LoginViewModel: NSObject {
    
    func userLogin(email: String, password: String) {
     
        NetworkLayer.shared.login(email: email, password: password) { token, error in
            if let token = token {
                
                KeychainManager.deleteBigToken()
                KeychainManager.saveDataBigToken(token: token)
                Global.loginStatus = true
                Global.tokenMaster = token
                
                print("Token valid during login")
                print("Email used for API call: \(email)")
                print("Token returned from API call: \(token)")
                print("Global.loginStatus: \(Global.loginStatus)\n\n")
                
                DispatchQueue.main.async {
                    UIApplication
                        .shared
                        .connectedScenes
                        .compactMap{ ($0 as? UIWindowScene)?.keyWindow }
                        .first?
                        .rootViewController = TabBarController()
                }
            } else {
                print("Login error: ", error?.localizedDescription ?? "\n")
            }
        }
    }
    
    static func isUserLoggedIn() -> Bool {
        return !KeychainManager.readBigToken()!.isEmpty
    }
}
