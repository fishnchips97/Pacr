//
//  Stopwatch.swift
//  Time Keeper
//
//  Created by Erik Fisher on 5/24/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import Foundation


class Stopwatch: ObservableObject {
    var secondsElapsed = 0.0 {
        didSet {
            objectWillChange.send()
        }
    }
    private var timer = Timer()
}

extension Stopwatch {
    func start() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                self.secondsElapsed += 0.01
            }
        }
    }
    
    func stop() {
        self.secondsElapsed = 0
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
    
}
