//
//  Night.swift
//  Nudge
//
//  Created by William Hickman on 6/5/19.
//  Copyright © 2019 William Hickman Ent. All rights reserved.
//

var night: Night?

import Foundation

class Night: Codable {
    
    let startDate: Date
    var asleepHours: Double
    var tookPill = false
    var didSet = false
    
    init(asleepHours: Double, startDate: Date) {
        self.asleepHours = asleepHours
        self.startDate = startDate
    }
    
}
