//
//  LoginViewController.swift
//  ios-practica
//
//  Created by Eric Olsson on 12/29/22.
//

import UIKit

class LoginViewController: UIViewController {

    public var userEmail:String = ""
    let keychain = KeychainManager()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        userEmail = emailTextField.text ?? "" // not used-------------!
        var userToken: String = ""
        
        guard let email = emailTextField.text, !email.isEmpty else {
            print("No email provided")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            print("No password provided")
            return
        }
        
        deleteTokens(service: "password mgmt", account: email) // turn this off later
        
        NetworkLayer.shared.login(email: email, password: password) { token, error in
            if let token = token {
                
                // Toggle line below for ease of logging in during testing
                LocalDataLayer.shared.saveEmailToUserDefaults(email: email)
                LocalDataLayer.shared.saveTokenToUserDefaults(token: token)
                
                self.savePassword(account: email, password: password)
                
                print("Token valid during login")
                print("User email = \(email)")
                print("User token = \(token)")
                
                userToken = token
                
                DispatchQueue.main.async {
                    UIApplication
                        .shared
                        .connectedScenes
                        .compactMap{ ($0 as? UIWindowScene)?.keyWindow }
                        .first?
                        .rootViewController = TabBarController()
                }
            } else {
                print("Login error: ", error?.localizedDescription ?? "")
            }
        }
        
        UserDefaults.standard.set(true, forKey: "login status") // set login status
        print("Login status: \(UserDefaults.standard.bool(forKey: "login status"))\n")
        
        sleep(2)
        deleteTokens(service: "password mgmt", account: email)
//        getPassword(account: email)
        savePassword(account: email, password: password) // ------ trying to move this line up
        getPassword(account: email)
        
        //print("bigToken = \(bigToken)\n")
        deleteTokens(service: "token mgmt", account: email)
//        getToken(account: email)
        saveToken(account: email, token: userToken)
        getToken(account: email)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func savePassword(account: String, password: String) {
        do {
            try KeychainManager.savePasswordInKeychain(service: "password mgmt", account: account, password: password.data(using: .utf8) ?? Data() // service was "facebook.com"
            )
        }
        catch {
            print("saveToken error: \(error)\n")
        }
    }

    func getPassword(account: String) {
        guard let data = KeychainManager.getPasswordFromKeychain(service: "password mgmt", account: account)
        else {
            print("Failed to read password from Keychain\n")
            return
        }
        
        let password = String(decoding: data, as: UTF8.self)
        print("Read password from Keychain: \(password)\n")
    }
    
    func saveToken(account: String, token: String) {
        
        do {
            try KeychainManager.saveTokenInKeychain(service: "token mgmt", account: account, token: token.data(using: .utf8) ?? Data()
            )
            print("saveToken successfull")
        }
        catch {
            print("saveToken error: \(error)\n")
        }
    }

    func getToken(account: String) {
        guard let data = KeychainManager.getTokenFromKeychain(service: "token mgmt", account: account)
        else {
            print("Failed to read token from Keychain\n")
            return
        }
        
        let token = String(decoding: data, as: UTF8.self)
        print("Read token from Keychain: \(token)\n")
    }
    
    func deleteTokens(service: String, account: String) {
        KeychainManager.deleteKeychainItem(service: service, account: account)
//        KeychainManager.deleteToken(service: "token mgmt", account: account)
    }
}
