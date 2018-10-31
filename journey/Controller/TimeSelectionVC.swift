//
//  TimeSelectionVC.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit

class TimeSelectionVC: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeSelectionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    
    var didSelectTime:((_ selectedTime: Date, _ timeType: APIManager.TimeType) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        timeSelectionSegmentedControl.tintColor = UIColor.flatGreen
        doneButton.tintColor = UIColor.flatGreen
        
        datePicker.minimumDate = Date()
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        switch timeSelectionSegmentedControl.selectedSegmentIndex {
        case 0:
            timeSelectionSegmentedControl.selectedSegmentIndex = 1
        default:
            break
        }
    }
    
    @IBAction func tappedOnDone(_ sender: UIButton) {
        if timeSelectionSegmentedControl.selectedSegmentIndex == 0 {
            self.didSelectTime?(datePicker.date, .leaveNow)
        }
        else if timeSelectionSegmentedControl.selectedSegmentIndex == 1 {
            self.didSelectTime?(datePicker.date, .departAfter)
        }
        else if timeSelectionSegmentedControl.selectedSegmentIndex == 2 {
            self.didSelectTime?(datePicker.date, .arriveBefore)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
