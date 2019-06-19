//
//  SelectNightViewController.swift
//  Nudge
//
//  Created by William Hickman on 6/7/19.
//  Copyright © 2019 William Hickman Ent. All rights reserved.
//

import UIKit

class SelectNightViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var nights: [Night]?
    var selected: Night?
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
    }
    
    // MARK: - UIPickerViewDataSource Methods

     // return number of columns/wheels
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nights!.count
     }
     
     // MARK: - UIPickerViewDelegate Methods
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dateFormatter.string(from: nights![row].startDate)
     }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? SleepAnalysisViewController {
            //destVC.selected = nights![pickerView.selectedRow(inComponent: 0)]
        }
    }
    

}
