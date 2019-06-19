//
//  ReportViewController.swift
//  Nudge
//
//  Created by William Hickman on 5/28/19.
//  Copyright © 2019 William Hickman Ent. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    
    var night: Night?
    var dateFormatter = DateFormatter()
    @IBOutlet var answerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateLabel.text = " Night of \(dateFormatter.string(from: night!.startDate))"
        answerLabel.text = ""
    }
    
    @IBAction func yesPressed(_ sender: Any) {
        night!.tookPill = true
        night!.didSet = true
        answerLabel.text = "Yes"
    }
    
    @IBAction func noPressed(_ sender: Any) {
        night!.tookPill = false
        night!.didSet = true
        answerLabel.text = "No"
    }

}
