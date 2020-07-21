//
//  distances.swift
//  Time Keeper
//
//  Created by Erik Fisher on 6/4/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import Foundation


let distances = ["20 m", "1 mile", "5 km", "10 km"]

let distanceFinishLinePcts : [Double] = distances.map { (dist) -> Double in
    let distanceInMeters = distanceMeasurements[dist]!.converted(to: .meters).value
    let distanceOfOneLap = distanceInMeters.truncatingRemainder(dividingBy: 400)
    
    return distanceOfOneLap / 400
}

let distanceMeasurements = [
    "20 m" : Measurement(value: 20, unit: UnitLength.meters),
    "1 mile" : Measurement(value: 1, unit: UnitLength.miles),
    "5 km" : Measurement(value: 5000, unit: UnitLength.meters),
    "10 km" : Measurement(value: 10000, unit: UnitLength.meters),
]


