//
//  LoginViewController.swift
//  ios-practica
//
//  Created by Eric Olsson on 12/29/22.
//

import UIKit

class LoginViewController: UIViewController {

    public var userEmail: String = ""
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
