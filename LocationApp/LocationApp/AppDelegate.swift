//
//  AppDelegate.swift
//  LocationApp
//
//  Created by Max Kuznetsov on 28.06.2022.
//

import UIKit
import UserNotifications
import CoreMotion
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let manager = CMMotionManager()
    var knocked : Bool = false
    let motionUpdateInterval : Double = 0.05
    var knockReset : Double = 2.0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared().isEnabled = true
        
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = motionUpdateInterval // seconds
            
            manager.startDeviceMotionUpdates(to: .main) {
                [weak self] (data, error) in
                
                
                if (data!.userAcceleration.z < -0.7) || (data!.userAcceleration.z > 0.7) { // Check if device is knocked
                    
                    // Check for double knock
                    if self!.knocked == false {
                        // First knock
                        print("First Knock")
                        self!.knocked = true
                        
                    }else{
                        // Second knock
                        print("Double Knocked")
                        self!.knocked = false
                        self!.knockReset = 2.0
                        
                        // Action:
                    }
                }
                
                // Countdown for reset action (second knock must be within the knockReset limit)
                if (self!.knocked) && (self!.knockReset >= 0.0) {
                    
                    self!.knockReset = self!.knockReset - self!.motionUpdateInterval
                    
                }else if self!.knocked == true {
                    self!.knocked = false
                    self!.knockReset = 2.0
                    print("Reset")
                }
                
            }
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}
