//
//  Media.swift
//  Nudge
//
//  Created by William Hickman on 5/27/19.
//  Copyright © 2019 William Hickman Ent. All rights reserved.
//

import Foundation
import UIKit

class Media {
    
    var title: String
    var stringAddress: String
    var type: String
    var minutes: Int
    var seconds: Int
    var genre: String
    
    init (title: String, stringAddress: String, type: String, minutes: Int, seconds: Int, genre: String) {
        self.title = title
        self.stringAddress = stringAddress
        self.type = type
        self.minutes = minutes
        self.seconds = seconds
        self.genre = genre
    }
    
}
