//
//  distances.swift
//  Pacr
//
//  Created by Erik Fisher on 6/4/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import Foundation

let distances = ["400 m", "1600 m", "5 km", "10 km"]
let availableDistanceUnits: [UnitLength] = [.miles, .kilometers]

let distanceFinishLinePcts : [Double] = distances.map { (dist) -> Double in
    let distanceInMeters = distanceMeasurements[dist]!.converted(to: .meters).value
    let distanceOfOneLap = distanceInMeters.truncatingRemainder(dividingBy: 400)
    
    return distanceOfOneLap / 400
}

let distanceMeasurements = [
    "400 m" : Measurement(value: 400, unit: UnitLength.meters),
    "1600 m" : Measurement(value: 1600, unit: UnitLength.meters),
    "5 km" : Measurement(value: 5000, unit: UnitLength.meters),
    "10 km" : Measurement(value: 10000, unit: UnitLength.meters),
]


