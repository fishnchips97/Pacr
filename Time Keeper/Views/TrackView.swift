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
    let distances = ["1 Mile", "10 Km", "Half Marathon"]
    
    
    
    var body: some View {
        ZStack {
            
        
            GeometryReader {
                geometry in
                HStack{
                    Spacer()
                    VStack {
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        
                        Path { path in
                            let rect = CGRect(x: geometry.size.width / 4, y: geometry.size.height / 8, width: geometry.size.width / 2, height: geometry.size.height / 2)
                            let size = CGSize(width: 100.0, height: 100.0)
                            
                            path.addRoundedRect(in: rect, cornerSize: size, style: .circular)
                        }
                        
                        //                        .fill(style: FillStyle(eoFill: false, antialiased: true))
                        
                        Text("Distance: \(self.tracker.distanceString)").font(.system(size: 24, design: .monospaced))
                        
                        
                        Text("Time: \(self.tracker.secondsElapsedString)").font(.system(size: 24, design: .monospaced))
                        Picker("Option Picker", selection: self.$selectedOption) {
                            ForEach(0 ..< self.distances.count) { index in
                                Text(self.distances[index]).tag(index)
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
                                self.tracker.currentDistanceGoal = self.distances[self.selectedOption]
                            }) {
                                Text("Start").bold()
                            }
                            .disabled(!self.disableOverlay)
                            .foregroundColor(.green)
                        }
                        Spacer()
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
