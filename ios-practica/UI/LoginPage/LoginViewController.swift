//
//  LoginViewController.swift
//  ios-practica
//
//  Created by Eric Olsson on 12/29/22.
//

import UIKit

class LoginViewController: UIViewController {

    public var userEmail: String = ""
    public var userToken: String = "" // only used for print statements, delete this...
    
    let keychain = KeychainManager()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            print("No email provided")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            print("No password provided")
            return
        }
        
        
        NetworkLayer.shared.login(email: email, password: password) { token, error in
            if let token = token {
                
                // Toggle line below for ease of logging in during testing
                LocalDataLayer.shared.saveEmailToUserDefaults(email: email)
                LocalDataLayer.shared.saveTokenToUserDefaults(token: token)
                KeychainManager.deleteBigToken()
                KeychainManager.saveDataBigToken(token: token)
//                self.keychain.readDataBigToken(username: "token-manager")
                KeychainManager.readBigToken()
                
                print("Token valid during login")
                print("User email = \(email)")
                print("User token = \(token)")
                
                
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
