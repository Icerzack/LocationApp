//
//  SettingsViewController.swift
//  LocationApp
//
//  Created by Max Kuznetsov on 28.06.2022.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    // MARK: - SettingsViewController fields
    private var toolBar = UIToolbar()
    private var picker = UIPickerView()
    
    @IBOutlet var timerIntervalLabel: UILabel!
    @IBOutlet var timerGlobalLabel: UILabel!
    
    private var currentPickedTimer: TimerProtocol!
    
    private var intervalTimer = IntervalTimer()
    private var globalTimer = GlobalTimer()
    
    // Value, which stands for picked global timer value
    private var currentGlobalTimerValue: String! {
        didSet {
            timerGlobalLabel.text = currentGlobalTimerValue
        }
    }
    
    // Value, which stands for picked interval timer value
    private var currentIntervalTimerValue: String! {
        didSet {
            timerIntervalLabel.text = currentIntervalTimerValue
        }
    }
    
    // MARK: - SettingsViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve settings if we have some
        if let globalTimerValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.globalTimer.rawValue){
            currentGlobalTimerValue = globalTimerValue
        } else {
            currentGlobalTimerValue = globalTimer.getPossibleTimers()[0]
        }
        
        if let intervalTimerValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.intervalTimer.rawValue){
            currentIntervalTimerValue = intervalTimerValue
        } else {
            currentIntervalTimerValue = intervalTimer.getPossibleTimers()[0]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Save all data we made in this controller
        UserDefaults.standard.setValue(currentGlobalTimerValue, forKey: UserDefaultsKeys.globalTimer.rawValue)
        UserDefaults.standard.setValue(currentIntervalTimerValue, forKey: UserDefaultsKeys.intervalTimer.rawValue)
    }
    
    // MARK: - Table View selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        // App settings
        case 0:
            if indexPath.row == 0{
                // Show PickerView
                showPickerView(currentSelection: globalTimer)
                
                // Making visual deselection of tapped row
                tableView.deselectRow(at: indexPath, animated: true)
            } else if indexPath.row == 1{
                // Show PickerView
                showPickerView(currentSelection: intervalTimer)
                
                // Making visual deselection of tapped row
                tableView.deselectRow(at: indexPath, animated: true)
            }
        // Telegram settings
        case 1:
            return
        // User settings
        case 2:
            if indexPath.row == 0{
                let loginVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController")
                
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginVC)
            }
        default:
            return
        }
        
    }
    
    // MARK: - Show Picker
    private func showPickerView(currentSelection selection: TimerProtocol){
        // Setting current selection
        currentPickedTimer = selection
        
        // Setting up a custom UIPickerView
        picker = UIPickerView.init()
        
        picker.delegate = self
        picker.dataSource = self
        
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 150)
        
        self.view.addSubview(picker)
        
        // Setting up a custom ToolBar, which is above UIPickerView
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        
        self.view.addSubview(toolBar)
        
    }
    
    // MARK: - Done button action
    @objc func onDoneButtonTapped() {
        // Remove toolBar and picker from screen
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        
        // Refresh text value of chosen property
        switch currentPickedTimer {
        case is GlobalTimer:
            currentGlobalTimerValue = currentPickedTimer.getPossibleTimers()[picker.selectedRow(inComponent: 0)]
        case is IntervalTimer:
            currentIntervalTimerValue = currentPickedTimer.getPossibleTimers()[picker.selectedRow(inComponent: 0)]
        default:
            break
        }
    }
    
}

// MARK: - Setting up a picker for timer
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentPickedTimer.getPossibleTimers().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentPickedTimer.getPossibleTimers()[row]
        
    }
    
}
