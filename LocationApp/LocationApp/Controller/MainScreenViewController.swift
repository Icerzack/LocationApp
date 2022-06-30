//
//  ViewController.swift
//  LocationApp
//
//  Created by Max Kuznetsov on 28.06.2022.
//

import UIKit
import SwiftyJSON
import CoreLocation
import MessageUI
import CoreMotion

class MainScreenViewController: UIViewController {
    
    // MARK: - ViewController fields
    @IBOutlet var tableView: UITableView!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var alarmButton: UIButton!
    
    // Value, which represents current picked by user timer interval
    private var currentTimer: String!
    
    let center = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()
    let serverManager = ServerManager()
    
    // Value, which stands for starting timestamp of previous location
    private var startTime: Date?
    
    // MARK: - ViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up rightBarButton, which show SettingsViewController
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(openSettingsController))
        
        // Request notifications permission
        center.requestAuthorization(options: [.alert, .sound, .alert]) { granted, error in
            guard granted else { return }
            self.center.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
            }
        }
    }
    
    func sendNotification(withText text: String, andInterval timeInterval: TimeInterval){
        // Creating content for notification
        let content = UNMutableNotificationContent()
        
        content.title = "First"
        content.body = "\(text)"
        content.sound = UNNotificationSound.default
        
        // Setting up trigger with specified time interval
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        // Performing notification request
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        center.add(request) { error in
            if error != nil{
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender == startButton{
            if startButton.titleLabel?.text == "Start"{
                // Creating json filled with data
                // TODO: add timer value
                let jsonStartButton: JSONData = [
                    JSONFields.event.rawValue:"alarm_button",
                    JSONFields.userId.rawValue:2342,
                    JSONFields.coords.rawValue:
                        [
                            JSONFields.x.rawValue:789,
                            JSONFields.y.rawValue:789
                        ]
                ]
                
                // TODO: Make data encryption
                
                // Sending json to server with specified URL
                // FIXME: Change url
                serverManager.sendJSON(withJSON: jsonStartButton, andURL: URL(string: "https://example.com")!)
                
                // Setting up Location manager, initiating location tracking
                setupLocationManager()
                
                // Changing text of button to 'Cancel'
                startButton.setTitle("Cancel", for: .normal)
                startButton.setTitleColor(UIColor.red, for: .normal)
            } else {
                // Creating json filled with data
                // TODO: add timer value
                let jsonStartButton: JSONData = [
                    JSONFields.event.rawValue:"cancel_timer",
                    JSONFields.userId.rawValue:2342,
                ]
                
                // TODO: Make data encryption
                
                // Sending json to server with specified URL
                // FIXME: Change url
                serverManager.sendJSON(withJSON: jsonStartButton, andURL: URL(string: "https://example.com")!)
                
                // Stop location tracking
                locationManager.stopUpdatingLocation()
                
                // Changing text of button to 'Start'
                startButton.setTitle("Start", for: .normal)
                startButton.setTitleColor(UIColor.blue, for: .normal)
            }
            
        } else if sender == alarmButton{
            // Creating json filled with data
            let jsonAlarmButton: JSONData = [
                JSONFields.event.rawValue:"alarm_button",
                JSONFields.userId.rawValue:2342,
                JSONFields.coords.rawValue:
                    [
                        JSONFields.x.rawValue:789,
                        JSONFields.y.rawValue:789
                    ]
            ]
            
            // TODO: Make data encryption
            
            // Sending json to server with specified URL
            // FIXME: Change url
            serverManager.sendJSON(withJSON: jsonAlarmButton, andURL: URL(string: "https://example.com")!)
            
            // Setting up Location manager, initiating location tracking
            setupLocationManager()
        }
    }
    
    @objc private func openSettingsController(){
        // Doing preparations before moving to SettingsViewController
        let sc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        // TODO: change doAfterFinish
        sc.doAfterFinish = { [self] time in
            currentTimer = time
            tableView.reloadData()
        }
        navigationController?.pushViewController(sc, animated: true)
    }
    
}

// MARK: - TableView setup
extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //FIXME: change numberOfRows for another appropriate value
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setting up a special cell with specified identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        cell.timerLabel.text = currentTimer
        
        return cell
    }
}

// MARK: - LocationManager delegate setup
extension MainScreenViewController: CLLocationManagerDelegate {
    
    func setupLocationManager(){
        locationManager.delegate = self
        
        // Initializing accuracy of GPS tracking
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        // Prompting user to allow tracking
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        // Enable opportunity to fetch data in background non-stop
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        // Invoke didUpdateLocations method
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Checking whether last location is available or not
        guard let loc = locations.last else { return }
        
        // Making a timestamp of last location
        let time = loc.timestamp
        
        // Check for the first time, if current initial time is nil (empty)
        guard startTime != nil else {
            self.startTime = time
            return
        }
        
        // Counting a timeInterval of last two locations
        let elapsed = time.timeIntervalSince(startTime!)
        
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
                        JSONFields.x.rawValue:789,
                        JSONFields.y.rawValue:789
                    ]
            ]
            
            //TODO: Make data encryption
            
            // Sending json to server with current coordinates
            // FIXME: Change url
            serverManager.sendJSON(withJSON: jsonCoordinates , andURL: URL(string: "https://example.com/")!)
        }
    }
    
}

