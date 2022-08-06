//
//  LocalNotificationManager.swift
//  LocationApp
//
//  Created by Max Kuznetsov on 01.07.2022.
//

import Foundation
import UserNotifications

class LocalNotificationManager{
    
    // Instance of notification center
    let center = UNUserNotificationCenter.current()
    
    func sendScheduledNotification(textBody text: String, userInfo info: [String:Any], timeInterval: TimeInterval, doesContainActions makeActions: Bool){
        // Creating content for notification
        let content = UNMutableNotificationContent()
        
        // Initializing two actions
        if makeActions {
            let alertAction = UNNotificationAction(identifier: "ALERT_ACTION",
                                                    title: "Alert!",
                                                    options: [])
            let cancelAction = UNNotificationAction(identifier: "CANCEL_ACTION",
                                                     title: "Cancel timer",
                                                     options: [])
            // Define the notification type
            let category =
                  UNNotificationCategory(identifier: "TIMER_NOTIFICATION",
                  actions: [alertAction, cancelAction],
                  intentIdentifiers: [],
                  hiddenPreviewsBodyPlaceholder: "",
                  options: .customDismissAction)
            
            center.setNotificationCategories([category])
        }
        
        // Filling notification with content
        content.title = "LocationApp timer!"
        content.body = "\(text)"
        content.sound = UNNotificationSound.default
        content.userInfo = info
        content.categoryIdentifier = "TIMER_NOTIFICATION"
        
        // Setting up trigger with specified time interval
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        // Performing notification request
        let request = UNNotificationRequest(identifier: "NOTIFICATION", content: content, trigger: trigger)
        
        center.add(request) { error in
            if error != nil{
                print(error!.localizedDescription)
            }
        }
    }
}
