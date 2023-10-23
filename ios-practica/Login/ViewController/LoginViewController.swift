//
//  LoginViewController.swift
//  ios-practica
//
//  Created by Eric Olsson on 12/29/22.
//

import UIKit

class LoginViewController: UIViewController, LoginViewModelDelegate {
 
    let loginViewModel = LoginViewModel()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            loginDidFailWithError(error: "No email provided")
            print("No email provided")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            loginDidFailWithError(error: "No password provided")
            print("No password provided")
            return
        }
        
        loginViewModel.userLogin(email: email, password: password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel.delegate = self
    }
    
    func loginDidFailWithError(error: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Login error", message: error, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
