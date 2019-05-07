//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Bobba Kadush on 5/6/19.
//  Copyright © 2019 Bobba Kadush. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var alarmButton: UIButton!
    

    var alarm: Alarm?{
        didSet{
            loadViewIfNeeded()
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    private func updateView(){
        guard let alarm = alarm else {return}
            datePicker.date = alarm.fireDate
            titleLabel.text = alarm.name
            updateEnabledButton()
        }
    
    
    func updateEnabledButton() {
        guard let alarm = alarm else {
            alarmButton.isHidden = true
            return
        }
        if alarm.enabled == true {
            alarmButton.backgroundColor = .red
            alarmButton.setTitle("Turn alarm off", for: .normal)
        }else {
            alarmButton.backgroundColor = .green
            alarmButton.setTitle("Turn alarm on", for: .normal)
        }
    }
    
    @IBAction func enableButtonTapped(_ sender: Any) {
        guard let alarm = alarm else { return }
       AlarmController.shared.toggleEnabled(for: alarm)
        updateEnabledButton()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleLabel.text else {return}
        guard title != "" else {return}
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireDate: datePicker.date, name: title, enabled: alarm.enabled)
        }else{
            AlarmController.shared.addAlarm(fireDate: datePicker.date, name: title, enabled: true)
        }
        navigationController?.popViewController(animated: true)
    }
    
}
