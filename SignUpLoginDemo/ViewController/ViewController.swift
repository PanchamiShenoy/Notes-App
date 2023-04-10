//
//  ViewController.swift
//  SignUpLoginDemo
//
//  Created by Panchami Shenoy on 18/10/21.
//

import UIKit

import UIKit
import FirebaseAuth
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
class ViewController: UIViewController{
    
    @IBOutlet weak var button1: FBLoginButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let token = AccessToken.current,
           !token.isExpired {
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            transitionToHome()
        }
        else{
            button1.permissions = ["public_profile", "email"]
            button1.delegate = self
            
        }
        let status = NetworkManager.shared.checkSignIn()
        if(status == true){
            self.transitionToHome()
        }
    }
    
    @IBAction func onLogin(_ sender: Any) {
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(title: "Error", message: "Please fill all the fields")
            return
        }
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        NetworkManager.shared.login(withEmail: email, password: password){ [weak self] result, error in
            if error != nil {
                self!.showAlert(title: "Error", message: "Error while Signing In")
            }
            else{
                self!.transitionToHome()
            }
        }
    }
    
}

extension ViewController :LoginButtonDelegate{
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        if token != "" {
            transitionToHome()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier:"ContainerViewController")
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}

