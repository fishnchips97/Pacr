//
//  TrackView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 1/21/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

let trackDistanceInMeters = 400.0


// stop with button: https://stackoverflow.com/questions/34211832/how-to-pause-a-cadisplaylink
//class CADisplayLinkBinding: NSObject, ObservableObject {
//
//    init(tracker: DistanceTimeTracker) {
//        self.tracker = tracker
//    }
//
//    var tracker: DistanceTimeTracker
//
//    private var displayLink: CADisplayLink?
//    private var startTime = 0.0
//    private let animLength = 5.0
////    var seconds = 0.12
//
//    func startDisplayLink() {
//
//        stopDisplayLink() // make sure to stop a previous running display link
//        startTime = CACurrentMediaTime() // reset start time
//
//        // create displayLink & add it to the run-loop
//        let displayLink = CADisplayLink(
//            target: self, selector: #selector(displayLinkDidFire)
//        )
//        displayLink.add(to: .main, forMode: .common)
////        displayLink.duration = 1 / 60
//        self.displayLink = displayLink
//    }
//
//    @objc func displayLinkDidFire(_ displayLink: CADisplayLink) {
//        let actualFramesPerSecond = 1 / (self.displayLink!.targetTimestamp - self.displayLink!.timestamp)
//        if self.tracker.runStatus != .inProgress {
//            self.displayLink?.isPaused = true
//            stopDisplayLink()
//        } else {
//            self.tracker.updateTime(fps: actualFramesPerSecond)
//        }
//        self.objectWillChange.send()
//    }
//
//    // invalidate display link if it's non-nil, then set to nil
//    func stopDisplayLink() {
//        self.displayLink?.invalidate()
//        self.displayLink = nil
//    }
//}


struct RecordingView: View {
    
    @ObservedObject private var tracker : DistanceTimeTracker
    //    @ObservedObject private var displayLink: CADisplayLinkBinding
    
    @State private var selectedOption: Int = 0
    
    @State private var targetAnimating = false
    @State private var currentAnimating = false
    @State private var currentPct : CGFloat = 0.0
    @State private var finishLinePcts : [CGFloat] = distanceFinishLinePcts.map {CGFloat($0)}
    
    
    
    @State private var show = false
    
    private let minuteOptions: [Int] = Array(1 ..< 60)
    @State private var minuteIndex = 6
    private let secondOptions: [Int] = Array(0 ..< 60)
    @State private var secondIndex = 0
    
    @State var distanceUnits: UnitLength = availableDistanceUnits[UserDefaults.standard.integer(forKey: "Distance Units Index")]
    
    
    
    init(tracker: DistanceTimeTracker) {
        self.tracker = tracker
    }
    
    
    
    
    var body: some View {
        ZStack {
            
            
            GeometryReader {
                geometry in
                
                VStack {
                    Spacer(minLength: 5)
                    RecordingInfoView(tracker: self.tracker,
                                      selectedOption: self.$selectedOption,
                                      targetAnimating: self.$targetAnimating,
                                      currentAnimating: self.$currentAnimating,
                                      currentPct: self.$currentPct,
                                      finishLinePcts: self.$finishLinePcts
                    )
                        .frame(width: geometry.size.width, height: geometry.size.height/1.7)
                    //                            .border(Color.black)
                    
                    
                    
                    
                    HStack {
                        VStack {
                            Text("Target Pace").font(.system(size: 16, design: .monospaced))
                            HStack {
                                Text("\(UnitFormatter.paceNumberToString(pace: Double(self.minuteOptions[self.minuteIndex] * 60 + self.secondOptions[self.secondIndex]), distanceUnit: self.distanceUnits))")
                                    .font(.system(size: 18, design: .monospaced))
                            }
                            Button(action: {
                                self.show.toggle()
                            }) {
                                Text("Edit")
                                    .bold()
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 20)
                                    .foregroundColor(Color.white)
                                    .background(Color.blue)
                                    .cornerRadius(15)
                            }
                            .disabled(self.tracker.runStatus != .notStarted)
                        }
                        .frame(width: geometry.size.width / 2)
                        
                        VStack {
                            Text("Avg. Pace").font(.system(size: 16, design: .monospaced))
                            HStack {
                                //                                    Text("\(self.tracker.pace)")
                                Text("\(UnitFormatter.pace(timeInSecs: self.tracker.secondsUpdatedOnDistanceChange, distance: self.tracker.distance, unit: self.distanceUnits))")
                                    .font(.system(size: 18, design: .monospaced))
                            }
                        }
                        .frame(width: geometry.size.width / 2)
                    }
                        
                    .padding(.horizontal)
                    
                    
                    
                    
                    //                        self.tracker.runStatus != .notStarted
                    PickerView(selectedOption: self.$selectedOption, isDisabled: self.tracker.runStatus != .notStarted)
                        .padding(.horizontal)
                    
                    Spacer(minLength: 0)
                    HStack{
                        Button(action: {
                            
                            withAnimation {
                                self.tracker.cancelRun()
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
                            if self.distanceUnits == .miles {
                                let mile = Measurement(value: 1, unit: UnitLength.miles)
                                let paceInSecondsPerMeter = Double(self.minuteOptions[self.minuteIndex] * 60 + self.secondOptions[self.secondIndex]) / mile.converted(to: .meters).value
                                animationTime = trackDistanceInMeters * paceInSecondsPerMeter
                            } else {
                                let kilometer = Measurement(value: 1, unit: UnitLength.kilometers)
                                let paceInSecondsPerMeter = Double(self.minuteOptions[self.minuteIndex] * 60 + self.secondOptions[self.secondIndex]) / kilometer.converted(to: .meters).value
                                animationTime = trackDistanceInMeters * paceInSecondsPerMeter
                            }
                            
                            withAnimation(Animation.linear(duration: animationTime).repeatForever(autoreverses: false)) {
                                self.targetAnimating = true
                            }
                            self.tracker.start()
                            self.tracker.currentDistanceGoal = distances[self.selectedOption]
                        }) {
                            Text("Start").bold()
                        }
                        .padding()
                        .background(Color.green)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        .disabled(self.tracker.runStatus == .inProgress)
                        
                    }
                    Spacer(minLength: 5)
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
                                .border(Color.red)
                                .clipped()
                            
                            Picker(selection: self.$secondIndex, label: Text("Second"), content: {
                                ForEach(0 ..< self.secondOptions.count) {
                                    Text("\(self.secondOptions[$0])").tag($0)
                                }
                                
                            })
                                .frame(maxWidth: geometry.size.width / 2)
                                .border(Color.green)
                                .clipped()
                        }
                    }.frame(height: 250)
                    
                    
                    
                    Button(action: {
                        self.show.toggle()
                    }) {
                        Text("Done")
                            .bold()
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(15)
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
            }
        }.onAppear {
            self.distanceUnits = availableDistanceUnits[UserDefaults.standard.integer(forKey: "Distance Units Index")]
        }
    }
}

struct PickerView: View {
    @Binding var selectedOption: Int
    var isDisabled: Bool
    
    var body: some View {
        Picker("Option Picker", selection: self.$selectedOption) {
            ForEach(0 ..< distances.count) { index in
                Text(distances[index]).tag(index)
            }
        }
        .padding(.horizontal)
        .pickerStyle(SegmentedPickerStyle())
        .disabled(self.isDisabled)
    }
}

struct RecordingView_Previews: PreviewProvider {
    
    static var previews: some View {
        RecordingView(tracker: DistanceTimeTracker())
    }
}
