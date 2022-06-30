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
    
    // FIXME: Find another approach to store possible timer values
    private var possibleTimers = ["30:00", "45:00", "1:00:00", "1:30:00", "2:00:00"]
    
    // Value, which stands for picked timer value
    private var currentTimerValue: String!
    
    // Closure, which will be called when <Back button pressed
    var doAfterFinish: ((String) -> Void)?

// MARK: - SettingsViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTimerValue = possibleTimers[0]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Performing closure when tapping <Back button in navigation bar
        if self.isMovingFromParent{
            doAfterFinish?(currentTimerValue)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // FIXME: Add more rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setting up a special cell with specified identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimerCell", for: indexPath) as! TimerCell
        
        cell.currentTimerLabel.text = currentTimerValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Checking, if tapped row is the first one, which stands for timer setup
        if indexPath.row == 0{
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
            
            // Making visual deselection of tapped row
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        
        // Refresh text value of current chosen timer
        currentTimerValue = possibleTimers[picker.selectedRow(inComponent: 0)]
        
        // Don't forget to refresh data, so changes could appear
        tableView.reloadData()
    }
    
}

// MARK: - Setting up a picker for timer
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // FIXME: Change numberOfRowsInComponent, so it depends on number of possible timers
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // FIXME: This array will be deleted, so don't forget to change reference
        return possibleTimers[row]
    }
    
}
