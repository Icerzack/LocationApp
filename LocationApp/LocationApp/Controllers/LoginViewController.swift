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
            let tabBarVC = TabBarController()
            
            tabBarVC.tabBar.backgroundColor = .white
            
            let mainVC = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainScreenViewController") as! MainViewController)
            let settingsVC = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController)
            
            mainVC.title = "Location App"
            settingsVC.title = "Settings"
            
            tabBarVC.setViewControllers([mainVC, settingsVC], animated: true)
            
            let tabBarImagesNames = ["location.circle", "gearshape"]
            
            guard let items = tabBarVC.tabBar.items else { return }
            
            for (index, item) in items.enumerated() {
                item.image = UIImage(systemName: tabBarImagesNames[index])
            }
            
            tabBarVC.modalPresentationStyle = .fullScreen
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarVC)
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

