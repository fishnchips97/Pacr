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
    @NSManaged public var distance: NSString?
}

extension Record {
    static func getAllRecords() -> NSFetchRequest<Record>{
        
        let request:NSFetchRequest<Record> = Record.fetchRequest() as! NSFetchRequest<Record>
        
        let sortDescriptor = NSSortDescriptor(key: "dateRecorded", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    
    
}
