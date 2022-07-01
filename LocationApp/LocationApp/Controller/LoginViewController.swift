//
//  LoginViewController.swift
//  LocationApp
//
//  Created by Max Kuznetsov on 01.07.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        //FIXME: need a real login and sign up
        if sender == signInButton {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let navigationController = storyboard.instantiateViewController(identifier: "NavigationController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navigationController)
        } else if sender == signUpButton {
            
        }
        
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

