//
//  SpeedAndDistanceTracker.swift
//  Time Keeper
//
//  Created by Erik Fisher on 5/27/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import Foundation
import CoreLocation

class SpeedDistanceTimeTracker : NSObject, ObservableObject {
    
    @Published var runCompleted = false
    private var timer = Timer()
    private let locationManager = LocationManager.shared
    var secondsElapsed = 0.0 {
        didSet {
            objectWillChange.send()
        }
    }
    var distance = Measurement(value: 0, unit: UnitLength.meters) {
        didSet {
            if self.distance >= Measurement(value: 15, unit: UnitLength.meters) {
                self.stop()
                self.locationManager.stopUpdatingLocation()
            }
            objectWillChange.send()
        }
    }
    private var locationList: [CLLocation] = []
    
    override init() {
        super.init()
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func startLocationUpdates() {
        self.locationManager.delegate = self
        self.locationManager.activityType = .fitness
        self.locationManager.distanceFilter = 10
        self.locationManager.startUpdatingLocation()
    }
    
}

extension SpeedDistanceTimeTracker : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let sinceNow = location.timestamp.timeIntervalSinceNow
            guard location.horizontalAccuracy < 20  && abs(sinceNow) < 10 else {
                continue
            }
            if let prevLocation = locationList.last {
                let dist = location.distance(from: prevLocation)
                distance = distance + Measurement(value: dist, unit: UnitLength.meters)
            }
            locationList.append(location)
        }
    }
}

extension SpeedDistanceTimeTracker {
    func start() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                self.secondsElapsed += 0.01
            }
        }
    }
    
    func stop() {
        runCompleted.toggle()
//        self.secondsElapsed = 0
        timer.invalidate()
    }
    
    var secondsElapsedString: String {
        var result = ""
        if self.hours != 0 {
            result += "\(self.hourString):"
        }
        result += "\(self.minuteString):\(self.secondString).\(self.centisecondString)"
        
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
    
    var centiseconds: Int {
        Int(Int((secondsElapsed - Double(Int(secondsElapsed))) * 100))
    }
    
    var centisecondString : String {
        String(format: "%02d", self.centiseconds)
    }
    
    var distanceString : String {
        String(format: "%05.2f meters", self.distance.value.roundTo(places: 2))
    }
}

extension SpeedDistanceTimeTracker {
    func completeRun() {
        runCompleted = true
    }
}


extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
