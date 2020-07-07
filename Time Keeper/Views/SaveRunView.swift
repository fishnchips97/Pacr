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
            Text("Time: \(self.tracker.secondsElapsedString)")
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
                    record.timeInSeconds = NSNumber(value: self.tracker.secondsElapsed.roundTo(places: 2))
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
