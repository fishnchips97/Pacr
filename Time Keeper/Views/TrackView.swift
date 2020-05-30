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
    @State var steps = 1
    
    private func beginRun() {
        
    }
    
    private func endRun() {
        
    }
    
    
    var body: some View {
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
                    if self.tracker.distance.value < 10 {
                        Text("Distance: \(self.tracker.distanceString)").font(.system(size: 24, design: .monospaced))
                    } else {
//                        self.tracker.stop()
                        Text("ok")
                    }
                    
                    Text("Time: \(self.tracker.secondsElapsedString)").font(.system(size: 24, design: .monospaced))
                    Stepper(value: self.$steps, in: 1...10) {
                        Text("Speed: \(self.steps)")
                    }
                    .padding(.horizontal)
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
                            let record = Record(context: self.managedObjectContext)
                            record.dateRecorded = Date()
                            print("test")
                            record.timeInSeconds = NSNumber(value: self.steps)
                            do {
                                print("ok")
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                            self.steps = 1
                            
                        }) {
                            Text("Submit").bold()
                        }
                        .disabled(!self.disableOverlay)
                        .foregroundColor(.green)
                        
                        Button(action: {
                            self.tracker.start()
                            self.tracker.startLocationUpdates()
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
    }
}

struct TrackView_Previews: PreviewProvider {
    
    static var previews: some View {
        TrackView(disableOverlay: .constant(false), overlayOpacity: .constant(0.5), trackBlur: .constant(0.5))
    }
}

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
