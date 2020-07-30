//
//  SaveRunView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 5/31/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct SaveRunView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var tracker : DistanceTimeTracker
    @Binding var targetAnimating : Bool
    @Binding var currentAnimating : Bool
    @Binding var currentPct : CGFloat
    
    
    var body: some View {
        VStack {
            Text("Save Time?")
            Text("Time: \(UnitFormatter.secondsToTraditionalFormatString(seconds: self.tracker.secondsElapsed))")
            Text("Distance: \(self.tracker.currentDistanceGoal)")

            HStack {
                Button(action: {
                    self.tracker.reset()
                }) {
                    Text("Cancel")
                }
                
                Button(action: {
                    let record = Record(context: self.managedObjectContext)
                    
                    record.dateRecorded = Date()
                    record.timeInSeconds = NSNumber(value: self.tracker.secondsElapsed)
                    record.distance = NSString(utf8String: self.tracker.currentDistanceGoal)
                    do {
                        try self.managedObjectContext.save()
                    } catch {
//                        print(error)
                    }
                    self.tracker.reset()
                }) {
                    Text("Save")
                }
            }
        }.onAppear(perform: {
            
            /// rescale the time if the gps updated way past the goal
            self.tracker.secondsElapsed *= distanceMeasurements[self.tracker.currentDistanceGoal]!.value / self.tracker.distance.value
            
            withAnimation {
                self.targetAnimating = false
                self.currentAnimating = false
                self.currentPct = 0.0
            }
            
        })
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        
    }
}

struct SaveRunView_Previews: PreviewProvider {
    static var previews: some View {
        SaveRunView(tracker: DistanceTimeTracker(), targetAnimating: .constant(false), currentAnimating: .constant(false), currentPct: .constant(0.0))
    }
}
