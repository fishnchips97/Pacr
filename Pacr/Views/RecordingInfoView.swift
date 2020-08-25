//
//  RecordingInfoView.swift
//  Pacr
//
//  Created by Erik Fisher on 7/31/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI
import AVFoundation

struct RecordingInfoView: View {
    
    
    @ObservedObject private var tracker : DistanceTimeTracker
    @Binding var selectedOption: Int
    @Binding var targetAnimating: Bool
    @Binding var currentAnimating: Bool
    @Binding var currentPct: CGFloat
    @Binding var finishLinePcts: [CGFloat]
    var targetPace: Double
    @Binding var behindPace: Bool
    @State var active = true

    @State var distanceUnits: UnitLength = availableDistanceUnits[UserDefaults.standard.integer(forKey: "Distance Units Index")]
    @State var buzzOn: Bool = !UserDefaults.standard.bool(forKey: "Buzz for lead change")
    let formatter = NumberFormatter()
    init(
        tracker: DistanceTimeTracker,
        selectedOption: Binding<Int>,
        targetAnimating: Binding<Bool>,
        currentAnimating: Binding<Bool>,
        currentPct: Binding<CGFloat>,
        finishLinePcts: Binding<[CGFloat]>,
        behindPace: Binding<Bool>,
        targetPace: Double
    ) {
        self.tracker = tracker
        self._selectedOption = selectedOption
        self._targetAnimating = targetAnimating
        self._currentAnimating = currentAnimating
        self._currentPct = currentPct
        self._finishLinePcts = finishLinePcts
        self._behindPace = behindPace
        self.targetPace = targetPace
        
        
        self.formatter.minimumFractionDigits = 0
        self.formatter.maximumFractionDigits = 2
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ZStack(alignment: .center) {
                    TrackView(
                        startAnimationTarget: self.$targetAnimating,
                        startAnimationCurrent: self.$currentAnimating,
                        currentPct: self.$currentPct,
                        finishLinePct: self.$finishLinePcts[self.selectedOption]
                    )
                        .frame(width: geometry.size.width / 1.9, height: geometry.size.height)
                        .onReceive(self.tracker.$stoppedRunning) { (stoppedRunning) in
                            
                            if self.tracker.runStatus == .inProgress && stoppedRunning == true {
                                withAnimation (Animation.linear(duration: 0)) {
                                    let currentDistance = self.tracker.distance
                                    let temp = currentDistance.converted(to: .meters)
                                    let val = temp.value.truncatingRemainder(dividingBy: trackDistanceInMeters)
                                    self.currentPct = CGFloat(val / trackDistanceInMeters)
                                    self.currentAnimating = false
                                }
                            }
                    }
                    .onReceive(self.tracker.$distance) { (currentDistance) in
                        if self.tracker.runStatus == .inProgress {
                            
                            let distanceSinceLastUpdate = currentDistance.converted(to: .meters) - self.tracker.distance.converted(to: .meters)
                            let currentSpeedInMetersPerSec = distanceSinceLastUpdate.value / self.tracker.secondsElapsedSinceLastUpdate
                            let transitionTime = trackDistanceInMeters / currentSpeedInMetersPerSec
                            if currentDistance.value > 0 {
                                withAnimation (Animation.linear(duration: 0)) {
                                    /// without this the other animation breaks
                                    self.currentAnimating = false
                                }
                                withAnimation(Animation.linear(duration: transitionTime)) {
                                    let temp = currentDistance.converted(to: .meters)
                                    let val = temp.value.truncatingRemainder(dividingBy: trackDistanceInMeters)
                                    self.currentPct = CGFloat(val / trackDistanceInMeters)
                                    self.currentAnimating = true
                                }
                            }
                            
                            let pacerDistance = self.tracker.secondsElapsed / self.targetPace
                            if self.behindPace != (currentDistance.converted(to: self.distanceUnits).value < pacerDistance) {
                                self.behindPace = (currentDistance.converted(to: self.distanceUnits).value < pacerDistance)
                                if self.buzzOn {
                                    if self.behindPace {
                                        // buzz twice
                                        if self.active {
                                            self.active = false
                                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                            var i = 0
                                            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { timer in
                                                if i == 0 {
                                                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                                } else if i == 1 {
                                                    self.active = true
                                                } else {
                                                    timer.invalidate()
                                                }
                                                i += 1
                                            }
                                        }
                                    } else {
                                        // buzz once
                                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .center, spacing: 0) {
                        Text("Laps")
                            .font(.system(size: 25))
                            .frame(width: geometry.size.width / 4, alignment: .leading)
                            .padding(.leading, 20)
                        Spacer(minLength: 10)
                        Text(self.formatter.string(from: self.tracker.distance.value / 400.0 as NSNumber)!)
                            .font(.system(size: 21, design: .monospaced))
                        Spacer(minLength: 0)
                        Divider()
                            .frame(width: 50, height: 20)
                        Spacer(minLength: 0)
                        Text(self.formatter.string(from: distanceMeasurements[distances[self.selectedOption]]!.value / 400.0 as NSNumber)!)
                            .font(.system(size: 21, design: .monospaced))
                        Spacer(minLength: 5)
                    }
                    .frame(width: geometry.size.width / 4, height: geometry.size.height / 7)
                }
                VStack {
                    Spacer(minLength: 5)
                    Text("Distance")
                        .font(.system(size: 24, design: .monospaced))
                        .underline()
                    Text("\(UnitFormatter.distanceString(distance: self.tracker.distance, unit: self.distanceUnits))")
                        .font(.system(size: 24, design: .monospaced))
                    Spacer(minLength: 10)
                    Text("Time")
                        .font(.system(size: 24, design: .monospaced))
                        .underline()
                    Text("\(UnitFormatter.secondsToTraditionalFormatString(seconds: self.tracker.secondsElapsed))")
                        .font(.system(size: 24, design: .monospaced))
                        
                        .frame(width: geometry.size.width / 2)
                    Spacer(minLength: 5)
                }
                .frame(width: geometry.size.width / 2.3, height: geometry.size.height/2)
            }
        }
        .onAppear {
            self.buzzOn = !UserDefaults.standard.bool(forKey: "Buzz for lead change")
        }
        
    }
}

struct RecordingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingInfoView(tracker: DistanceTimeTracker(),
                          selectedOption: .constant(0),
                          targetAnimating: .constant(false),
                          currentAnimating: .constant(false),
                          currentPct: .constant(0.0),
                          finishLinePcts: .constant([CGFloat]([1.0, 0.5, 1.0])),
                          behindPace: .constant(false),
                          targetPace: 5.0
            
        )
    }
}
