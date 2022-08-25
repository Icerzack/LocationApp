//
//  ViewController.swift
//  LocationApp
//
//  Created by Max Kuznetsov on 28.06.2022.
//

import UIKit
import CoreLocation

class MainScreenViewController: UIViewController {
    
    // MARK: - ViewController fields
    
    @IBOutlet var startButton: UIButton!
    @IBOutlet var alarmButton: UIButton!
    
    // Value, which represents current picked by user global timer interval
    private var currentGlobalTimer: String!
    
    // Value, which represents current picked by user interval timer interval
    private var currentIntervalTimer: String!
    
    private let localNotificationManager = LocalNotificationManager()
    private let locationManager = CLLocationManager()
    private let serverManager = ServerManager()
    
    // Value, which stands for starting timestamp of previous location
    private var startTime: Date?
    
    // Value, which refers to current user position
    private var currentLocation: CLLocation?
    
    // Value, which determines the current mode
    private var isOn: Bool = false
    
    private let url = "https://ptsv2.com/t/qcmzf-1656676919/post"
    
    // MARK: - ViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up notifications delegate
        localNotificationManager.center.delegate = self
        
        navigationItem.title = "Location App"
        
        // Rounding and coloring buttons
        startButton.layer.cornerRadius = 0.5 * startButton.bounds.size.width
        startButton.backgroundColor = UIColor.systemGreen
        startButton.tintColor = UIColor.white
        
        alarmButton.layer.cornerRadius = 0.5 * alarmButton.bounds.size.width
        alarmButton.backgroundColor = UIColor.red
        alarmButton.tintColor = UIColor.white
        
        // Prompting user to allow tracking
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        // Setting up location manager properties
        setupLocationManager()
        
        // Request notifications permission
        localNotificationManager.center.requestAuthorization(options: [.alert, .sound, .alert]) { granted, error in
            guard granted else { return }
            self.localNotificationManager.center.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve data for timers if we have such
        if let globalTimerValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.globalTimer.rawValue){
            currentGlobalTimer = globalTimerValue
        }
        
        if let intervalTimerValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.intervalTimer.rawValue){
            currentIntervalTimer = intervalTimerValue
        }
    }
    
    // MARK: - Buttons touch setup
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender == startButton{
            if startButton.titleLabel?.text == "Start"{
                // Creating json filled with data
                // FIXME: pass a real timers values
                let jsonStartButton: JSONData = [
                    JSONFields.event.rawValue:"start_timer",
                    JSONFields.userId.rawValue:2342,
                    JSONFields.timerValue.rawValue:1,
                    JSONFields.intervalValue.rawValue:1
                ]
                
                // TODO: Make data encryption
                
                // Sending json to server with specified URL
                serverManager.sendJSON(withJSON: jsonStartButton, andURL: URL(string: url)!)
                
                // Storing a local notification with timer value
                //FIXME: change user_id ant timeinterval
                localNotificationManager.sendScheduledNotification(textBody: "Hey, timer is over. Are you ok?", userInfo: ["USER_ID":1234], timeInterval: 7, doesContainActions: true)
                
                // Initiating location tracking
                isOn = true
                locationManager.startUpdatingLocation()
                
                // Changing text of button to 'Cancel'
                startButton.setTitle("Cancel", for: .normal)
                startButton.setTitleColor(UIColor.red, for: .normal)
                
                
            } else {
                // Creating json filled with data
                let jsonStartButton: JSONData = [
                    JSONFields.event.rawValue:"cancel_timer",
                    JSONFields.userId.rawValue:2342,
                ]
                
                // TODO: Make data encryption
                
                // Sending json to server with specified URL
                serverManager.sendJSON(withJSON: jsonStartButton, andURL: URL(string: url)!)
                
                // Stop location tracking
                isOn = false
                locationManager.stopUpdatingLocation()
                
                // Changing text of button to 'Start'
                startButton.setTitle("Start", for: .normal)
                startButton.setTitleColor(UIColor.white, for: .normal)
            }
            
        } else if sender == alarmButton{
            // Requesting current coordinates
            if !isOn {
                locationManager.startUpdatingLocation()
            }
            
            // Using DispatchQueue to delay request to server so location manager has some time
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { [self] in
                // Creating json filled with data
                let jsonAlarmButton: JSONData = [
                    JSONFields.event.rawValue:"alarm_button",
                    JSONFields.userId.rawValue:2342,
                    JSONFields.coords.rawValue:
                        [
                            JSONFields.x.rawValue:currentLocation?.coordinate.longitude,
                            JSONFields.y.rawValue:currentLocation?.coordinate.latitude
                        ]
                ]
                
                // TODO: Make data encryption
                
                // Sending json to server with specified URL
                serverManager.sendJSON(withJSON: jsonAlarmButton, andURL: URL(string: url)!)
                
                // Cancel execution of location manager if it wasn't previously launched
                if !isOn {
                    locationManager.stopUpdatingLocation()
                }
            }
        }
    }
}

// MARK: - Location setup

extension MainScreenViewController: CLLocationManagerDelegate {
    
    private func setupLocationManager(){
        locationManager.delegate = self
        
        // Initializing accuracy of GPS tracking
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        // Enable opportunity to fetch data in background non-stop
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var loc: CLLocation!
        var time: Date!
        
        loc = locations.last
        currentLocation = loc
        guard isOn == true else {
            return
        }
        
        // Making a timestamp of last location
        time = loc?.timestamp
        
        // Check for the first time, if current initial time is nil (empty)
        guard startTime != nil else {
            self.startTime = time
            return
        }
        
        // Counting a timeInterval of last two locations
        let elapsed = (time?.timeIntervalSince(startTime!))!
        
        // If passed time is more than 'seconds', than renew startTime and send data to server
        // FIXME: Make another time limit in didUpdateLocations
        if elapsed > 5 {
            // Renew the start time for this location
            startTime = time
            
            // Create json to send
            let jsonCoordinates: JSONData = [
                JSONFields.event.rawValue:"interval_timer",
                JSONFields.userId.rawValue:2342,
                JSONFields.coords.rawValue:
                    [
                        JSONFields.x.rawValue:loc?.coordinate.longitude,
                        JSONFields.y.rawValue:loc?.coordinate.latitude
                    ]
            ]
            
            //TODO: Make data encryption
            
            // Sending json to server with current coordinates
            serverManager.sendJSON(withJSON: jsonCoordinates , andURL: URL(string: url)!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //TODO: do something if there is no opportunity to request location
        print(error.localizedDescription)
    }
}

// MARK: - Handling notification

extension MainScreenViewController: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Perform the task associated with the action.
        switch response.actionIdentifier {
        case "ALERT_ACTION":
            // Create json to send
            let jsonAlarmButton: JSONData = [
                JSONFields.event.rawValue:"alarm_button",
                JSONFields.userId.rawValue:2342,
                JSONFields.coords.rawValue:
                    [
                        JSONFields.x.rawValue:currentLocation?.coordinate.longitude,
                        JSONFields.y.rawValue:currentLocation?.coordinate.latitude
                    ]
            ]
            //TODO: Make data encryption
            
            // Sending json to server with current coordinates
            serverManager.sendJSON(withJSON: jsonAlarmButton , andURL: URL(string: url)!)
            break
            
        case "CANCEL_ACTION":
            // Create json to send
            let jsonCoordinates: JSONData = [
                JSONFields.event.rawValue:"cancel_timer",
                JSONFields.userId.rawValue:2424,
            ]
            
            //TODO: Make data encryption
            
            // Sending json to server with current coordinates
            serverManager.sendJSON(withJSON: jsonCoordinates , andURL: URL(string: url)!)
            
            // Canceling timer and location tracking
            isOn = false
            locationManager.stopUpdatingLocation()
            
            // Changing text of button to 'Start'
            startButton.setTitle("Start", for: .normal)
            startButton.setTitleColor(UIColor.white, for: .normal)
            break
            
        default:
            break
        }
        
        completionHandler()
    }
    
}
