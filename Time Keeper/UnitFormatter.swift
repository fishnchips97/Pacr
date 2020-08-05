//
//  UnitFormatter.swift
//  Time Keeper
//
//  Created by Erik Fisher on 7/18/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import Foundation

class UnitFormatter {
    
    static func secondsToTraditionalFormatString(seconds: Double, fractionalDigits: Int = 2) -> String {
        let safeFractionalDigits = fractionalDigits > 2 ? 2 : fractionalDigits
        
        let formatter = DateComponentsFormatter()
        
        
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        let milliseconds = modf(seconds).1
        let numFormatter = NumberFormatter()
        
        numFormatter.maximumIntegerDigits = 0
        numFormatter.minimumIntegerDigits = 0
        numFormatter.maximumFractionDigits = safeFractionalDigits
        numFormatter.minimumFractionDigits = safeFractionalDigits

        let msString = safeFractionalDigits <= 0 ? "" : numFormatter.string(from: NSNumber(value: milliseconds))!
        var formattedString = formatter.string(from: TimeInterval(seconds))!
        if seconds < 3600 {
            formattedString = formattedString.replacingOccurrences(of: "00:", with: "")
        }
//        print(seconds, formattedString)
        
        let timeStringWithMilliseconds = formattedString + msString
        
        return timeStringWithMilliseconds
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
        let start = secondsToTraditionalFormatString(seconds: pace, fractionalDigits: 0)
        return "\(start) /\(distanceUnit.symbol)"
        
    }
    
    static func pace(timeInSecs: Double, distance: Measurement<UnitLength>, unit: UnitLength) -> String {
        
        var paceNumber = 0.0
        if distance.converted(to: unit).value > 0.0 {
            paceNumber = timeInSecs / distance.converted(to: unit).value
        }
        return "\(UnitFormatter.secondsToTraditionalFormatString(seconds: paceNumber, fractionalDigits: 0)) /\(unit.symbol)"
        
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
