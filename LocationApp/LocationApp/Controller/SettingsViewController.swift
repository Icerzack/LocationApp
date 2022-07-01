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
    
    // FIXME: Find another approach to store possible timer values
    private var possibleGlobalTimers = ["30:00", "45:00", "1:00:00", "1:30:00", "2:00:00"]
    private var possibleIntervalTimers = ["15:00"]
    private var currentSelection: String?
    
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
    
    // Closure, which will be called when <Back button pressed
    var doAfterFinish: ((_ globalTimer: String, _ intervalTimer: String) -> Void)?
    
    // MARK: - SettingsViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        currentGlobalTimerValue = possibleGlobalTimers[0]
        currentIntervalTimerValue = possibleIntervalTimers[0]
        navigationItem.title = "Settings"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Performing closure when tapping <Back button in navigation bar
        if self.isMovingFromParent{
            doAfterFinish?(currentGlobalTimerValue, currentIntervalTimerValue)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            // Checking, if tapped row is the first one, which stands for global timer setup
            if indexPath.row == 0{
                // Show PickerView
                showPickerView(currentSelection: "Global")
                
                // Making visual deselection of tapped row
                tableView.deselectRow(at: indexPath, animated: true)
            } else if indexPath.row == 1{
                // Show PickerView
                showPickerView(currentSelection: "Interval")
                
                // Making visual deselection of tapped row
                tableView.deselectRow(at: indexPath, animated: true)
            }
        case 1:
            fallthrough
        default:
            return
        }
        
    }
    
    private func showPickerView(currentSelection selection: String){
        // Setting current selection
        currentSelection = selection
        
        // Setting up a custom UIPickerView
        picker = UIPickerView.init()
        
        picker.delegate = self
        picker.dataSource = self
        
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        
        self.view.addSubview(picker)
        
        // Setting up a custom ToolBar, which is above UIPickerView
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        
        self.view.addSubview(toolBar)
        
    }
    
    @objc func onDoneButtonTapped() {
        // Remove toolBar and picker from screen
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        
        // Refresh text value of chosen property
        switch currentSelection {
        case "Global":
            currentGlobalTimerValue = possibleGlobalTimers[picker.selectedRow(inComponent: 0)]
        case "Interval":
            currentIntervalTimerValue = possibleIntervalTimers[picker.selectedRow(inComponent: 0)]
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
        // FIXME: Change numberOfRowsInComponent, so it depends on number of possible timers
        switch currentSelection{
        case "Global":
            return possibleGlobalTimers.count
        case "Interval":
            return possibleIntervalTimers.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // FIXME: This array will be deleted, so don't forget to change reference
        switch currentSelection{
        case "Global":
            return possibleGlobalTimers[row]
        case "Interval":
            return possibleIntervalTimers[row]
        default:
            return ""
        }
        
    }
    
}
