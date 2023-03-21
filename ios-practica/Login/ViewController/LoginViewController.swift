//
//  LoginViewController.swift
//  ios-practica
//
//  Created by Eric Olsson on 12/29/22.
//

import UIKit

class LoginViewController: UIViewController {
 
    let loginViewModel = LoginViewModel()
    
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
        
        loginViewModel.userLogin(email: email, password: password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
