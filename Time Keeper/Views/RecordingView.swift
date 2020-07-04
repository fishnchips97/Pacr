//
//  TrackView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 1/21/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct RecordingView: View {
    
    @ObservedObject var tracker = DistanceTimeTracker()
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var disableOverlay : Bool
    @Binding var overlayOpacity : Double
    @Binding var trackBlur      : Double
    @State private var selectedOption: Int = 0
    @State private var targetAnimating = false
    @State private var currentAnimating = false
    @State private var currentPct : CGFloat = 0.0
    
    let trackDistanceInMeters = 400.0
    let metersInMile = 1609.34
    @State private var show = false
    
    let minuteOptions: [Int] = Array(1 ..< 60)
    @State var minuteIndex = 6
    let secondOptions: [Int] = Array(0 ..< 60)
    @State var secondIndex = 0
    
    
    
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
                            currentPct: self.$currentPct
                        )
                            .padding()
                            .frame(width: geometry.size.width, height: geometry.size.height/1.6)
                            .onReceive(self.tracker.$distance) { (currentDistance) in
                                let distanceSinceLastUpdate = currentDistance.converted(to: .meters) - self.tracker.distance.converted(to: .meters)
                                let currentSpeedInMetersPerSec = distanceSinceLastUpdate.value / self.tracker.secondsElapsedSinceLastUpdate
                                let transitionTime = self.trackDistanceInMeters / currentSpeedInMetersPerSec
                                if currentDistance.value > 0 {
                                    withAnimation (Animation.linear(duration: 0)) {
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
                        
                        Text("Distance: \(self.tracker.distanceString) \(distanceMeasurements[distances[self.selectedOption]]?.unit.symbol ?? "")")
                            .font(.system(size: 24, design: .monospaced))
                            
                        
                        
                        Text("Time: \(self.tracker.secondsElapsedString)").font(.system(size: 24, design: .monospaced))
                        VStack {
                            Text("Target Pace").font(.system(size: 24, design: .monospaced))
                            HStack {
                                Text("\(String(format: "%02d", self.minuteOptions[self.minuteIndex])) : \(String(format: "%02d", self.secondOptions[self.secondIndex]))")
                                    .font(.system(size: 24, design: .monospaced))
                            }
                            Button(action: {
                                self.show.toggle()
                            }) {
                                Text("change")
                            }
                            .disabled(self.tracker.runStatus != .notStarted || !self.disableOverlay)
                        }
                        VStack {
                            Text("Average Pace").font(.system(size: 24, design: .monospaced))
                            HStack {
                                Text("\(self.tracker.pace)")
                                    .font(.system(size: 24, design: .monospaced))
                            }
                        }
                        
                        
                        Picker("Option Picker", selection: self.$selectedOption) {
                            ForEach(0 ..< distances.count) { index in
                                Text(distances[index]).tag(index)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                            .disabled(self.tracker.runStatus != .notStarted || !self.disableOverlay)
                            .padding()
                        HStack{
                            
                            Button(action: {
                                withAnimation {
                                    self.disableOverlay.toggle()
                                    self.overlayOpacity = 1.0
                                    self.trackBlur = 5.0
                                    self.tracker.stop()
                                    self.tracker.runStatus = .notStarted
                                    self.targetAnimating = false
                                    self.currentAnimating = false
                                    self.currentPct = 0.0
                                }
                            }) {
                                Text("Cancel")
                            }
                            .disabled(!self.disableOverlay)
                            
                            
                            Button(action: {
                                let paceInSecondsPerMeter = Double(self.minuteOptions[self.minuteIndex] * 60 + self.secondOptions[self.secondIndex]) / self.metersInMile
                                let animationTime = self.trackDistanceInMeters * paceInSecondsPerMeter
                                withAnimation(Animation.linear(duration: animationTime).repeatForever(autoreverses: false)) {
                                    self.targetAnimating = true
                                }
                                self.tracker.start()
                                self.tracker.currentDistanceGoal = distances[self.selectedOption]
                                self.tracker.updatePace()
                            }) {
                                Text("Start").bold()
                            }
                            .disabled(!self.disableOverlay)
                            .foregroundColor(.green)
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
        RecordingView(disableOverlay: .constant(false), overlayOpacity: .constant(0.5), trackBlur: .constant(0.5))
    }
}
