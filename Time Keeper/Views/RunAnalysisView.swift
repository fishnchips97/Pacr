//
//  RunAnalysisView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 7/8/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct RunAnalysisView: View {
    var run : Record
    var runs : [Record]
    
    @State var distanceUnits: UnitLength = availableDistanceUnits[UserDefaults.standard.integer(forKey: "Distance Units Index")]
    
    var pace : Double {
        let rec = self.run
        return UnitFormatter.paceNumber(timeInSecs: rec.timeInSeconds as! Double, distance: distanceMeasurements[rec.distance!.description]!, unit: self.distanceUnits)
    }
    var paces : [Double] {
        self.runs.map { (rec) -> Double in
            UnitFormatter.paceNumber(timeInSecs: rec.timeInSeconds as! Double, distance: distanceMeasurements[rec.distance!.description]!, unit: self.distanceUnits)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .leading, spacing: 0) {
                Text("\(self.run.distance!.description)")
                    .font(.system(size: 40))
                    .bold()
                    .padding(.vertical, 10)
                
                DotGraphView(yData: self.paces, highlightData: self.pace)
                    .frame(width: geometry.size.width - 30, height: 300)
                
                Spacer()
                Text("\(self.run.time) seconds")
                    .font(.system(size: 40))
                    .padding()
                Text("\(UnitFormatter.dateToString(date: self.run.dateRecorded))")
                    .font(.system(size: 20))
                    .padding()
                
                Spacer()
                    
                    
                    .navigationBarTitle(Text("Analysis"), displayMode: .inline)
            }
        }
        
    }
}

struct RunAnalysisView_Previews: PreviewProvider {
    
    static var previews: some View {
        let rec1 = Record()
        
        rec1.dateRecorded = Date()
        rec1.timeInSeconds = NSNumber(value: 1500.21.roundTo(places: 2))
        rec1.distance = NSString(utf8String: "10 km")
        
        let rec2 = Record()
        
        rec2.dateRecorded = Date()
        rec2.timeInSeconds = NSNumber(value: 1000.21.roundTo(places: 2))
        rec2.distance = NSString(utf8String: "10 km")
        
        let rec3 = Record()
        
        rec3.dateRecorded = Date()
        rec3.timeInSeconds = NSNumber(value: 2000.21.roundTo(places: 2))
        rec3.distance = NSString(utf8String: "10 km")
        
        let runs = [rec1, rec2, rec3]
        
        return RunAnalysisView(run: rec1, runs: runs)
    }
}
