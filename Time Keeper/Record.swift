//
//  Record.swift
//  Time Keeper
//
//  Created by Erik Fisher on 1/21/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import Foundation
import CoreData

public class Record:NSManagedObject, Identifiable {
    @NSManaged public var timeInSeconds: NSNumber?
    @NSManaged public var dateRecorded: Date?
//    @NSManaged public var pace: NSNumber?
}

extension Record {
    static func getAllRecords() -> NSFetchRequest<Record>{
        
        let request:NSFetchRequest<Record> = Record.fetchRequest() as! NSFetchRequest<Record>
        
        let sortDescriptor = NSSortDescriptor(key: "dateRecorded", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    var time: String {

        let timeInSecs = timeInSeconds?.doubleValue
        let totalSeconds = timeInSecs ?? 0
        let hours = Int(totalSeconds) / 3600
        let minutes = (Int(totalSeconds) % 3600) / 60
        let seconds = Int(totalSeconds) % 60
//        let milliseconds = totalSeconds - Double(Int(totalSeconds))
        var result = ""
        if hours != 0 {
            result += "\(hours):"
        }
        let minuteString = String(format: "%02d", minutes)
        let secondString = String(format: "%02d", seconds)
        result += "\(minuteString):\(secondString)"

        return result

    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        if let date = dateRecorded {
            return dateFormatter.string(from: date)
        }
        return ""
    }
}
