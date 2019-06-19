//
//  ForecastViewController.swift
//  Nudge
//
//  Created by William Hickman on 6/10/19.
//  Copyright © 2019 William Hickman Ent. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    var night: Night?
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var prediction: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let level = getLevel()
        icon.image = UIImage(named: "emo\(level).png")
        
        let first = "Level \(level+1) Day Forecasted - "
        var second: String
        switch (level) {
        case 2:
            second = "REALLY BAD DAY AHEAD"
        case 1:
            second = "Tough day ahead"
        default:
            second = "Nice Job!  Piece of cake"
        }
        prediction.text = first + second
    }
    
    func getLevel() -> Int {
        var level = 0
        if night!.asleepHours < 7 {
            level += 1
        }
        if !night!.tookPill && night!.didSet{
            level += 1
        }
        return level
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
