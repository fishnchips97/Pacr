//
//  TrackView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 1/21/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct RecordingView: View {
    
    @ObservedObject var tracker = SpeedDistanceTimeTracker()
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var disableOverlay : Bool
    @Binding var overlayOpacity : Double
    @Binding var trackBlur      : Double
    @State private var selectedOption: Int = 0
    @State private var isRunning = false
    @State private var targetMinutes = 0
    @State private var targetSeconds = 30
    @State private var currentPct : CGFloat = 0.0
    
    let trackDistanceInMeters = 400.0
    
    
    
    var body: some View {
        ZStack {
            
            
            GeometryReader {
                geometry in
                HStack{
                    Spacer()
                    VStack {
                        TrackView(targetSeconds: self.$targetSeconds, targetMinutes: self.$targetMinutes, startAnimation: self.$isRunning, currentPct: self.$currentPct)
                            .padding()
                            .frame(width: geometry.size.width, height: geometry.size.height/1.5)
                            .onReceive(self.tracker.$distance) { (status) in
                                if status.value > 0 {
                                    withAnimation (Animation.linear(duration: 0.1)) {
                                        self.isRunning = false
                                        
                                    }
                                    withAnimation(Animation.linear(duration: Double(self.targetMinutes * 60 + self.targetSeconds))) {
                                        let temp = status.converted(to: .meters)
                                        let val = temp.value.truncatingRemainder(dividingBy: self.trackDistanceInMeters)
                                        self.currentPct = CGFloat(val / self.trackDistanceInMeters)
                                        self.isRunning = true
                                    }
                                }
                            }
                        Text("Distance: \(self.tracker.distanceString)")
                            .font(.system(size: 24, design: .monospaced))
                            
                        
                        
                        Text("Time: \(self.tracker.secondsElapsedString)").font(.system(size: 24, design: .monospaced))
                        Spacer()
                        TargetPacePicker(targetMinutes: self.$targetMinutes, targetSeconds: self.$targetSeconds)
                        VStack {
                            Text("Current Pace").font(.system(size: 24, design: .monospaced))
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
                                    self.isRunning = false
                                    self.tracker.runStatus = .notStarted
                                }
                            }) {
                                Text("Cancel")
                            }
                            .disabled(!self.disableOverlay)
                            
                            
                            Button(action: {
//                                withAnimation(Animation.linear(duration: Double(self.targetMinutes * 60 + self.targetSeconds)).repeatForever(autoreverses: false)) {
//                                }
                                self.isRunning = true
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
            if self.tracker.runStatus == .finished {
                SaveRunView(tracker: self.tracker)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .environment(\.managedObjectContext, self.managedObjectContext)
                )
            }
        }
    }
}

struct RecordingView_Previews: PreviewProvider {
    
    static var previews: some View {
        RecordingView(disableOverlay: .constant(false), overlayOpacity: .constant(0.5), trackBlur: .constant(0.5))
    }
}


struct TargetPacePicker: View {
    @Binding var targetMinutes: Int
    @Binding var targetSeconds: Int
    var body: some View {
        VStack {
            Text("Target Pace").font(.system(size: 24, design: .monospaced))
            HStack {
                Text("\(String(format: "%02d", self.targetMinutes)) : \(String(format: "%02d", self.targetSeconds))")
                    .font(.system(size: 24, design: .monospaced))
            }
        }
    
    }
}
