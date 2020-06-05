//
//  TrackView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 1/21/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct TrackView: View {

    @ObservedObject var tracker = SpeedDistanceTimeTracker()
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var disableOverlay : Bool
    @Binding var overlayOpacity: Double
    @Binding var trackBlur : Double
    @State private var selectedOption: Int = 0
    @State private var isRunning = false
    @State private var minutes = 0
    @State private var seconds = 0
    
    
    
    var body: some View {
        ZStack {
            
        
            GeometryReader {
                geometry in
                HStack{
                    Spacer()
                    VStack {
                        Spacer()
                        
                        Path { path in
                            let rect = CGRect(x: geometry.size.width / 4, y: geometry.size.height / 8, width: geometry.size.width / 2, height: geometry.size.height / 2)
                            let size = CGSize(width: 100.0, height: 100.0)
                            
                            path.addRoundedRect(in: rect, cornerSize: size, style: .circular)
                        }
                        
                        //                        .fill(style: FillStyle(eoFill: false, antialiased: true))
                        Text("Distance: \(self.tracker.distanceString)").font(.system(size: 24, design: .monospaced))
                        
                        
                        Text("Time: \(self.tracker.secondsElapsedString)").font(.system(size: 24, design: .monospaced))
                        Spacer()
                        Text("Target Pace").font(.system(size: 24, design: .monospaced))
                        HStack {
                            Text("\(String(format: "%02d", self.minutes)) : \(String(format: "%02d", self.seconds))").font(.system(size: 24, design: .monospaced))
                        }
                        HStack {
                            Stepper(onIncrement: {
                                self.minutes += 1
                            }, onDecrement: {
                                if self.minutes >= 1 {
                                    self.minutes -= 1
                                }
                                }, label: {Text("")})
                            Stepper(onIncrement: {
                                self.seconds += 1
                            }, onDecrement: {
                                if self.seconds >= 1 {
                                    self.seconds -= 1
                                }
                            }, label: {Text("")})
                        }.labelsHidden()
                        
                        
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
                                }
                            }) {
                                Text("Cancel")
                            }
                            .disabled(!self.disableOverlay)
                            
                            
                            Button(action: {
                                self.tracker.start()
                                self.isRunning.toggle()
                                self.tracker.currentDistanceGoal = distances[self.selectedOption]
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
            if self.tracker.runStatus == runStatusPossibilities.finished {
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

struct TrackView_Previews: PreviewProvider {
    
    static var previews: some View {
        TrackView(disableOverlay: .constant(false), overlayOpacity: .constant(0.5), trackBlur: .constant(0.5))
    }
}
