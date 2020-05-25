//
//  TrackView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 1/21/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct TrackView: View {

    @ObservedObject var stopwatch = Stopwatch()
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var disableOverlay : Bool
    @Binding var overlayOpacity: Double
    @Binding var trackBlur : Double
    @State var steps = 1
    
    
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
                    Text("Distance:")
//                    HStack {
//                        Text("Time: ")
////                        Spacer().frame(width: 2)
//                        Text(String(self.stopwatch.minuteString)).frame(width: 22)
////                        Spacer().frame(width: 2)
//                        Text(":")
////                        Spacer().frame(width: 2)
//                        Text(String(self.stopwatch.secondString)).frame(width: 22)
//                        Text(".")
////                        Spacer().frame(width: 2)
//                        Text(String(self.stopwatch.centisecondString)).frame(width: 22)
//                    }
                    Text("\(self.stopwatch.secondsElapsedString)").frame(maxWidth: .infinity, alignment: .center).font(.system(size: 14, design: .monospaced))
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
                                self.stopwatch.stop()
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
                            self.stopwatch.start()
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
