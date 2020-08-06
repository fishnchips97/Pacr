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
    
    @ObservedObject var tracker : DistanceTimeTracker
    @Binding var targetAnimating : Bool
    @Binding var currentAnimating : Bool
    @Binding var currentPct : CGFloat
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .leading, spacing: 10) {
                Text("Save Time?")
                    .font(.system(size: 25))
                    .padding()
                Text("\(self.tracker.currentDistanceGoal)")
                    .font(.system(size: 22))
                    .padding()
                Text("\(UnitFormatter1.secondsToTraditionalFormatString(seconds: self.tracker.secondsElapsed)) seconds")
                    .font(.system(size: 24))
                    .padding()
                
                HStack {
                    Spacer()
                    Button(action: {
                        self.tracker.reset()
                    }) {
                        Text("Cancel")
                            .bold()
                    }
                    .padding()
                    .background(Color.red)
                    .cornerRadius(15)
                    .foregroundColor(Color.white)
                    Spacer()
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
                            .bold()
                    }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(15)
                    .foregroundColor(Color.white)
                    Spacer()
                }
            }
            .frame(width: geometry.size.width / 1.7)
            .onAppear(perform: {
                
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
}

struct SaveRunView_Previews: PreviewProvider {
    static var previews: some View {
        SaveRunView(tracker: DistanceTimeTracker(), targetAnimating: .constant(false), currentAnimating: .constant(false), currentPct: .constant(0.0))
    }
}
