//
//  Time.swift
//  Time Keeper
//
//  Created by Erik Fisher on 7/18/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import Foundation

class Time {
    
    
    static func secondsToTraditionalFormatString(seconds: Double) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional

        let formattedString = formatter.string(from: TimeInterval(seconds))!
        
        return formattedString
    }
    
    
    
}
