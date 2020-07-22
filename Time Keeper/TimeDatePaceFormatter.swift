//
//  Time.swift
//  Time Keeper
//
//  Created by Erik Fisher on 7/18/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import Foundation

class TimeDatePaceFormatter {
    
    
    static func secondsToTraditionalFormatString(seconds: Double) -> String {
        
        let formatter = DateComponentsFormatter()
        if seconds > 3600 {
            formatter.allowedUnits = [.minute, .second]
        } else {
            formatter.allowedUnits = [.hour, .minute, .second]
        }
        
        formatter.unitsStyle = .positional

        let formattedString = formatter.string(from: TimeInterval(seconds))!
        
        return formattedString
    }
    
    static func paceNumberToFormatString(pace: Double) -> String {
        let start = secondsToTraditionalFormatString(seconds: pace)
        return "\(start) min/mi"
    }
    
    static func dateToString(date: Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    static func pace(timeInSecs: Double, distance: Measurement<UnitLength>) -> String {
        let paceNumber = timeInSecs / distance.converted(to: .miles).value
        let pace = "\(TimeDatePaceFormatter.secondsToTraditionalFormatString(seconds: paceNumber)) min/mi"
        return pace
    }
    
    static func paceNumber(timeInSecs: Double, distance: Measurement<UnitLength>) -> Double {
        return timeInSecs / distance.converted(to: .miles).value
    }
    
    
}
