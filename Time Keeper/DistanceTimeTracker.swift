//
//  SpeedAndDistanceTracker.swift
//  Time Keeper
//
//  Created by Erik Fisher on 5/27/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import Foundation
import CoreLocation


enum runStatusPossibilities {
    case notStarted
    case inProgress
    case finished
}

class DistanceTimeTracker : NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var runStatus = runStatusPossibilities.notStarted
    var currentDistanceGoal = distances.first ?? ""
    private var timer = Timer()
    private let locationManager = LocationManager.shared
    var secondsElapsed = 0.0 {
        didSet {
            objectWillChange.send()
        }
    }
    var secondsUpdatedOnDistanceChange = 0.0
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
            secondsUpdatedOnDistanceChange = secondsElapsed
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
        self.locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func startLocationUpdates() {
        self.locationManager.delegate = self
        self.locationManager.activityType = .fitness
        self.locationManager.distanceFilter = 1
        self.locationManager.startUpdatingLocation()
    }
    
    func reset() {
        self.runStatus = .notStarted
        self.distance = Measurement(value: 0, unit: UnitLength.meters)
        self.secondsElapsed = 0.0
        self.secondsElapsedSinceLastUpdate = 0.0
        self.secondsUpdatedOnDistanceChange = 0.0
        self.locationList.removeAll()
    }
    
}

extension DistanceTimeTracker {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let sinceNow = location.timestamp.timeIntervalSinceNow
            guard location.horizontalAccuracy < 20 && abs(sinceNow) < 10 else {
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
    
    
    
}

extension DistanceTimeTracker {
    func completeRun() {
        self.runStatus = .finished
        self.locationManager.stopUpdatingLocation()
    }
}

