//
//  TrackView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 1/21/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct RecordingView: View {
    
    @ObservedObject private var tracker = DistanceTimeTracker()
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    

    @State private var selectedOption: Int = 0
    
    @State private var targetAnimating = false
    @State private var currentAnimating = false
    @State private var currentPct : CGFloat = 0.0
    @State private var finishLinePcts : [CGFloat] = distanceFinishLinePcts.map {CGFloat($0)}
    
    private let trackDistanceInMeters = 400.0
    
    @State private var show = false
    
    private let minuteOptions: [Int] = Array(1 ..< 60)
    @State private var minuteIndex = 6
    private let secondOptions: [Int] = Array(0 ..< 60)
    @State private var secondIndex = 0
    
    @State var distanceUnits = UserDefaults.standard.string(forKey: "Distance Units")
    
    var body: some View {
        ZStack {
            
            
            GeometryReader {
                geometry in
                HStack{
                    Spacer()
                    VStack {
                        TrackView(
                            startAnimationTarget: self.$targetAnimating,
                            startAnimationCurrent: self.$currentAnimating,
                            currentPct: self.$currentPct,
                            finishLinePct: self.$finishLinePcts[self.selectedOption]
                        )
                            .padding()
                            .frame(width: geometry.size.width, height: geometry.size.height/1.8)
                            .onReceive(self.tracker.$stoppedRunning) { (stoppedRunning) in

                                if self.tracker.runStatus == .inProgress && stoppedRunning == true {
                                    withAnimation (Animation.linear(duration: 0)) {
                                        let currentDistance = self.tracker.distance
                                        let temp = currentDistance.converted(to: .meters)
                                        let val = temp.value.truncatingRemainder(dividingBy: self.trackDistanceInMeters)
                                        self.currentPct = CGFloat(val / self.trackDistanceInMeters)
                                        self.currentAnimating = false
                                    }
                                }
                            }
                            .onReceive(self.tracker.$distance) { (currentDistance) in
                                if self.tracker.runStatus == .inProgress {
                                    let distanceSinceLastUpdate = currentDistance.converted(to: .meters) - self.tracker.distance.converted(to: .meters)
                                    let currentSpeedInMetersPerSec = distanceSinceLastUpdate.value / self.tracker.secondsElapsedSinceLastUpdate
                                    self.tracker.secondsElapsedSinceLastUpdate = 0.0
                                    let transitionTime = self.trackDistanceInMeters / currentSpeedInMetersPerSec
                                    if currentDistance.value > 0 {
                                        withAnimation (Animation.linear(duration: 0)) {
                                            /// without this the other animation breaks
                                            self.currentAnimating = false
                                        }
                                        withAnimation(Animation.linear(duration: transitionTime)) {
                                            let temp = currentDistance.converted(to: .meters)
                                            let val = temp.value.truncatingRemainder(dividingBy: self.trackDistanceInMeters)
                                            self.currentPct = CGFloat(val / self.trackDistanceInMeters)
                                            self.currentAnimating = true
                                        }
                                    }
                                }
                            }
                        
                        HStack {
                            VStack {
                                Text("Distance")
                                    .font(.system(size: 24, design: .monospaced))
                                    .underline()
                                Text("\(self.tracker.distanceString) \(distanceMeasurements[distances[self.selectedOption]]?.unit.symbol ?? "")")
                                .font(.system(size: 24, design: .monospaced))
                            }
                            .padding()
                            .frame(width: geometry.size.width / 2)
                            
                            
                            
                            VStack {
                                Text("Time")
                                    .font(.system(size: 24, design: .monospaced))
                                    .underline()
                                Text("\(self.tracker.secondsElapsedString)")
                                    .font(.system(size: 24, design: .monospaced))
                            }
                            .padding()
                            .frame(width: geometry.size.width / 2)
                        }
                        
                        
                        HStack {
                            VStack {
                                Text("Target Pace").font(.system(size: 16, design: .monospaced))
                                HStack {
                                    Text("\(String(format: "%02d", self.minuteOptions[self.minuteIndex])) : \(String(format: "%02d", self.secondOptions[self.secondIndex]))")
                                        .font(.system(size: 18, design: .monospaced))
                                }
                                Button(action: {
                                    self.show.toggle()
                                }) {
                                    Text("change")
                                }
                                .disabled(self.tracker.runStatus != .notStarted)
                            }
                            .padding()
                            .frame(width: geometry.size.width / 2)
                            
                            VStack {
                                Text("Avg. Pace").font(.system(size: 16, design: .monospaced))
                                HStack {
                                    Text("\(self.tracker.pace)")
                                        .font(.system(size: 18, design: .monospaced))
                                }
                            }
                            .padding()
                            .frame(width: geometry.size.width / 2)
                        }
                        
                        
                        
                        
                        Picker("Option Picker", selection: self.$selectedOption) {
                            ForEach(0 ..< distances.count) { index in
                                Text(distances[index]).tag(index)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                            .disabled(self.tracker.runStatus != .notStarted)
                            .padding()
                        HStack{
                            
                            Button(action: {
                                withAnimation {
                                    self.tracker.stop()
                                    self.tracker.runStatus = .notStarted
                                    self.targetAnimating = false
                                    self.currentAnimating = false
                                    self.currentPct = 0.0
                                }
                                self.tracker.reset()
                            }) {
                                Text("Cancel")
                            }
                            .padding()
                            .background(Color.red)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                            
                            
                            Button(action: {
                                var animationTime = 0.0
                                if self.distanceUnits == "Miles" {
                                    let mile = Measurement(value: 1, unit: UnitLength.miles)
                                    let paceInSecondsPerMeter = Double(self.minuteOptions[self.minuteIndex] * 60 + self.secondOptions[self.secondIndex]) / mile.converted(to: .meters).value
                                    animationTime = self.trackDistanceInMeters * paceInSecondsPerMeter
                                } else {
                                    let kilometer = Measurement(value: 1, unit: UnitLength.kilometers)
                                    let paceInSecondsPerMeter = Double(self.minuteOptions[self.minuteIndex] * 60 + self.secondOptions[self.secondIndex]) / kilometer.converted(to: .meters).value
                                    animationTime = self.trackDistanceInMeters * paceInSecondsPerMeter
                                }
                                
                                withAnimation(Animation.linear(duration: animationTime).repeatForever(autoreverses: false)) {
                                    self.targetAnimating = true
                                }
                                self.tracker.start()
                                self.tracker.currentDistanceGoal = distances[self.selectedOption]
                                self.tracker.updatePace()
                            }) {
                                Text("Start").bold()
                            }
                            .padding()
                            .background(Color.green)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                        }
                    }
                    Spacer()
                }
                //                        .background(Color.red)
                
            }
            if show {
                VStack {
                    HStack {
                        Text("\(String(format: "%02d", self.minuteOptions[self.minuteIndex])) : \(String(format: "%02d", self.secondOptions[self.secondIndex]))")
                            .font(.system(size: 24, design: .monospaced))
                    }
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            Picker(selection: self.$minuteIndex, label: Text("Minute"), content: {
                                ForEach(0 ..< self.minuteOptions.count) {
                                    Text("\(self.minuteOptions[$0])").tag($0)
                                }
                                
                            })
                                .frame(maxWidth: geometry.size.width / 2)
                                .clipped()
                            
                            Picker(selection: self.$secondIndex, label: Text("Second"), content: {
                                ForEach(0 ..< self.secondOptions.count) {
                                    Text("\(self.secondOptions[$0])").tag($0)
                                }
                                
                            })
                                .frame(maxWidth: geometry.size.width / 2)
                                .clipped()
                        }
                    }.frame(height: 250)
                    
                    
                    
                    Button(action: {
                        self.show.toggle()
                    }) {
                        Text("Done")
                    }
                    
                }.labelsHidden()
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .offset(x: 0, y: -50)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                )
            }
            if self.tracker.runStatus == .finished {
                SaveRunView(tracker: self.tracker, targetAnimating: self.$targetAnimating, currentAnimating: self.$currentAnimating, currentPct: self.$currentPct)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                )
                .environment(\.managedObjectContext, self.managedObjectContext)
            }
        }
    }
}

struct RecordingView_Previews: PreviewProvider {
    
    static var previews: some View {
        RecordingView()
    }
}
