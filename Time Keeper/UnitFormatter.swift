//
//  Time.swift
//  Time Keeper
//
//  Created by Erik Fisher on 7/18/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import Foundation

class UnitFormatter {
    
    static func secondsToTraditionalFormatString(seconds: Double) -> String {
        
        let formatter = DateComponentsFormatter()
        if seconds < 3600 {
            formatter.allowedUnits = [.minute, .second]
        } else {
            formatter.allowedUnits = [.hour, .minute, .second]
        }
        
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        let formattedString = formatter.string(from: TimeInterval(seconds))!
        
        return formattedString
    }
    
    
    static func dateToString(date: Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    static func paceNumberToString(pace: Double, distanceUnit: UnitLength) -> String {
        let start = secondsToTraditionalFormatString(seconds: pace)
        return "\(start) min/\(distanceUnit.symbol)"
        
    }
    
    static func pace(timeInSecs: Double, distance: Measurement<UnitLength>, unit: UnitLength) -> String {
        
        var paceNumber = 0.0
        if distance.converted(to: unit).value > 0.0 {
            paceNumber = timeInSecs / distance.converted(to: unit).value
        }
        return "\(UnitFormatter.secondsToTraditionalFormatString(seconds: paceNumber)) min/\(unit.symbol)"
        
    }
    
    static func paceNumber(timeInSecs: Double, distance: Measurement<UnitLength>, unit: UnitLength) -> Double {
        return timeInSecs / distance.converted(to: unit).value
    }
    
    static func distanceString(distance: Measurement<UnitLength>, unit: UnitLength) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.numberFormatter = NumberFormatter()
        formatter.numberFormatter.minimumIntegerDigits = 2
        formatter.numberFormatter.minimumFractionDigits = 2
        formatter.numberFormatter.maximumFractionDigits = 2
        formatter.unitOptions = .providedUnit
        
        let convertedDistance = distance.converted(to: unit)
        
        
        return "\(formatter.string(from: convertedDistance))"
    }
}
