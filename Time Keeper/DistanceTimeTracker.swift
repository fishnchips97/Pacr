//
//  SpeedAndDistanceTracker.swift
//  Time Keeper
//
//  Created by Erik Fisher on 5/27/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import Foundation
import CoreLocation


let trackDistanceInMeters = 400.0

enum runStatusPossibilities {
    case notStarted
    case inProgress
    case finished
}



class DistanceTimeTracker : NSObject, ObservableObject {
    
    
    
    @Published var runStatus = runStatusPossibilities.notStarted
    var currentDistanceGoal = distances.first ?? ""
    private var timer = Timer()
    var pace = "00:00 min/mi"
    private let locationManager = LocationManager.shared
    var secondsElapsed = 0.0 {
        didSet {
            objectWillChange.send()
        }
    }
    var secondsElapsedSinceLastUpdate = 0.0 {
        didSet {
            if secondsElapsedSinceLastUpdate >= 10 && stoppedRunning == false {
                stoppedRunning.toggle()
            }
        }
    }
    @Published var stoppedRunning = false
    @Published var distance = Measurement(value: 0, unit: UnitLength.meters) {
        didSet {
            stoppedRunning = false
            if let goal = distanceMeasurements[self.currentDistanceGoal] {
                if self.distance >= goal {
                    self.stop()
                }
            }
        }
    }
    private var locationList: [CLLocation] = []
    
    override init() {
        super.init()
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func startLocationUpdates() {
        self.locationManager.delegate = self
        self.locationManager.activityType = .fitness
        self.locationManager.distanceFilter = 1
        self.locationManager.startUpdatingLocation()
    }
    
    func reset() {
        self.pace = "00:00 min/mi"
        self.runStatus = .notStarted
        self.distance = Measurement(value: 0, unit: UnitLength.meters)
        self.secondsElapsed = 0.0
        self.locationList.removeAll()
    }
    
}

extension DistanceTimeTracker : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let sinceNow = location.timestamp.timeIntervalSinceNow
            guard location.horizontalAccuracy < 20 && abs(sinceNow) < 10 else {
                continue
            }
            if let prevLocation = locationList.last {
                let dist = location.distance(from: prevLocation)
                distance = distance + Measurement(value: dist, unit: UnitLength.meters)
                
                updatePace()
            }
            locationList.append(location)
        }
        
    }
}

extension DistanceTimeTracker {
    func start() {
        self.startLocationUpdates()
        self.runStatus = .inProgress
        if !timer.isValid {
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.secondsElapsed += 0.1
                self.secondsElapsedSinceLastUpdate += 0.1
            }
            timer.tolerance = 0.05
        }
    }
    
    func stop() {

        self.locationManager.stopUpdatingLocation()
        self.runStatus = runStatusPossibilities.finished
        timer.invalidate()
    }
    
    var secondsElapsedString: String {
        var result = ""
        if self.hours != 0 {
            result += "\(self.hourString):"
        }
        result += "\(self.minuteString):\(self.secondString).\(self.decisecondString)"
        
        return result
    }
    
    var hours: Int {
        Int(Int(secondsElapsed) / 3600)
    }
    
    var hourString : String {
        String(format: "%02d", self.hours)
    }
    
    var minutes: Int {
        Int((Int(secondsElapsed) % 3600) / 60)
    }
    
    var minuteString : String {
        String(format: "%02d", self.minutes)
    }
    
    var seconds: Int {
        Int(Int(secondsElapsed) % 60)
    }
    
    var secondString : String {
        String(format: "%02d", self.seconds)
    }
    
    var deciseconds: Int {
        Int((secondsElapsed - secondsElapsed.rounded(.down)) * 10)
    }
    
    var decisecondString : String {
        String(format: "%1d", self.deciseconds)
    }
    
    var distanceString : String {
        // using without units because units will be appended from view
//        let goal = distanceMeasurements[self.currentDistanceGoal]?.unit.symbol  ?? ""
        let unit = distanceMeasurements[self.currentDistanceGoal]!.unit
        return String(format: "%05.2f", self.distance.converted(to: unit).value.roundTo(places: 2))
    }
    
    func updatePace() {
        let convertedDistance = self.distance.converted(to: .miles)
        let pace = convertedDistance.value > 0 ? Double(self.secondsElapsed) / convertedDistance.value / 60: 0
        let paceSeconds = modf(pace).1 * 60
        self.pace = String(format: "%02.f:%02.f min/\(convertedDistance.unit.symbol)", pace, paceSeconds)
    }
    
    
}

extension DistanceTimeTracker {
    func completeRun() {
        self.runStatus = .finished
    }
}


extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded(.down) / divisor
    }
}
