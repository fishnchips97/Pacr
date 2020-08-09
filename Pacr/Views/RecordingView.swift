//
//  TrackView.swift
//  Pacr
//
//  Created by Erik Fisher on 1/21/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

let trackDistanceInMeters = 400.0


struct RecordingView: View {
    
    @ObservedObject private var tracker : DistanceTimeTracker
    
    @State private var selectedOption: Int = 0
    
    @State private var targetAnimating = false
    @State private var currentAnimating = false
    @State private var currentPct : CGFloat = 0.0
    @State private var finishLinePcts : [CGFloat] = distanceFinishLinePcts.map {CGFloat($0)}
    
    
    
    @State private var show = false
    
    private let targetPaceData: [[Int]] = [
        Array(1 ..< 60),
        Array(0 ..< 60)
    ]

    @State private var selectionIndexes: [Int] = [6, 0]
    
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
                                Text("\(UnitFormatter.paceNumberToString(pace: Double(self.targetPaceData[0][self.selectionIndexes[0]] * 60 + self.targetPaceData[1][self.selectionIndexes[1]]), distanceUnit: self.distanceUnits))")
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
                                Text("\(UnitFormatter.pace(timeInSecs: self.tracker.secondsUpdatedOnDistanceChange, distance: self.tracker.distance, unit: self.distanceUnits))")
                                    .font(.system(size: 18, design: .monospaced))
                            }
                        }
                        .frame(width: geometry.size.width / 2)
                    }
                        
                    .padding(.horizontal)
                    
                    
                    
                    
                    DistancePickerView(selectedOption: self.$selectedOption, isDisabled: self.tracker.runStatus != .notStarted)
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
                                let paceInSecondsPerMeter = Double(self.targetPaceData[0][self.selectionIndexes[0]] * 60 + self.targetPaceData[1][self.selectionIndexes[1]]) / mile.converted(to: .meters).value
                                animationTime = trackDistanceInMeters * paceInSecondsPerMeter
                            } else {
                                let kilometer = Measurement(value: 1, unit: UnitLength.kilometers)
                                let paceInSecondsPerMeter = Double(self.targetPaceData[0][self.selectionIndexes[0]] * 60 + self.targetPaceData[1][self.selectionIndexes[1]]) / kilometer.converted(to: .meters).value
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
                
                
            }
            if show {
                VStack {
                    HStack {
                        Text("\(String(format: "%02d", self.targetPaceData[0][self.selectionIndexes[0]])) : \(String(format: "%02d", self.targetPaceData[1][self.selectionIndexes[1]]))")
                            .font(.system(size: 24, design: .monospaced))
                    }
                    
                    PickerView(data: self.targetPaceData, selections: self.$selectionIndexes)
                        .frame(height: 250)
                    
                    
                    
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

struct DistancePickerView: View {
    @Binding var selectedOption: Int
    var isDisabled: Bool
    
    var body: some View {
        Picker("Option Picker", selection: self.$selectedOption) {
            ForEach(0 ..< distances.count) { index in
                Text(distances[index]).tag(index)
            }
        }
        .frame(width: 300)
        .pickerStyle(SegmentedPickerStyle())
        .disabled(self.isDisabled)
    }
}

struct RecordingView_Previews: PreviewProvider {
    
    static var previews: some View {
        RecordingView(tracker: DistanceTimeTracker())
    }
}
