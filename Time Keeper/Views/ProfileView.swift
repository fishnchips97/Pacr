//
//  ProfileView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 7/9/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    //    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Record.getAllRecords()) var records:FetchedResults<Record>
    @State var distanceUnits: UnitLength = availableDistanceUnits[UserDefaults.standard.integer(forKey: "Distance Units Index")]
    @State private var defaultDistanceIndex: Int = 0
    private var best1600m : Record? {
        fastestRecord(records: Array(records), distance: "1600 m")
    }
    private var best5k : Record? {
        fastestRecord(records: Array(records), distance: "5 km")
    }
    private var best10k : Record? {
        fastestRecord(records: Array(records), distance: "10 km")
    }
    
    
    private func fastestRecord(records: [Record], distance: String) -> Record? {
        var result = records.filter { (record) -> Bool in
            if timeRanges[defaultTimeRangeIndex] == "3 Months" {
                let threeMonthsInSeconds = 2592000.0
                //                let threeMonthsInSeconds = 600.0
                let timeSinceRecordDateInSeconds = Double(Date().timeIntervalSince(record.dateRecorded ?? Date()))
                return timeSinceRecordDateInSeconds < threeMonthsInSeconds
            }
            return true
        }
        result = result.filter { (record) -> Bool in
            record.distance?.description == distance
        }
        
        return result.min { (rec1, rec2) -> Bool in
            rec1.timeInSeconds!.doubleValue < rec2.timeInSeconds!.doubleValue
        }
    }
    
    private var avgTime1600m : String {
        var result = Array(records).filter { (record) -> Bool in
            if timeRanges[defaultTimeRangeIndex] == "3 Months" {
                let threeMonthsInSeconds = 2592000.0
                //                let threeMonthsInSeconds = 600.0
                let timeSinceRecordDateInSeconds = Double(Date().timeIntervalSince(record.dateRecorded ?? Date()))
                return timeSinceRecordDateInSeconds < threeMonthsInSeconds
            }
            return true
        }
        result = result.filter { (record) -> Bool in
            record.distance?.description == "1600 m"
        }
        var sum = 0.0
        for record in result {
            sum += record.timeInSeconds!.doubleValue
        }
        if sum == 0.0 {
            return "00:00"
        }
        let avgSeconds = sum / Double(result.count)
        return UnitFormatter.secondsToTraditionalFormatString(seconds: avgSeconds)
    }
    @State var defaultTimeRangeIndex: Int = 0
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
//                    HStack {
//                        Image(systemName: "person.circle")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: geometry.size.width / 7, height: geometry.size.height / 9)
//                        
//                        //                        Spacer(minLength: geometry.size.width / 7)
//                        Spacer()
//                        
//                        VStack {
//                            Spacer()
//                            Text("100")
//                                .bold()
//                                .font(.system(size: 20))
//                                .padding(.top, 10)
//                            
//                            Spacer()
//                            Text("Followers")
//                                .bold()
//                                .font(.system(size: 18))
//                                .padding(.bottom, 15)
//                        }
//                        .padding()
//                        .frame(width: geometry.size.width / 3.5, height: geometry.size.height / 9)
//                        .foregroundColor(Color.white)
//                        .background(Color.black)
//                        .cornerRadius(10)
//                        
//                        
//                        VStack {
//                            Spacer()
//                            Text("100")
//                                .bold()
//                                .font(.system(size: 20))
//                                .padding(.top, 10)
//                            
//                            Spacer()
//                            Text("Following")
//                                .bold()
//                                .font(.system(size: 18))
//                                .padding(.bottom, 15)
//                        }
//                        .padding()
//                        .frame(width: geometry.size.width / 3.5, height: geometry.size.height / 9)
//                        .foregroundColor(Color.white)
//                        .background(Color.black)
//                        .cornerRadius(10)
//                        
//                        Spacer()
//                    }
//                    .frame(height: geometry.size.height / 8)
//                    .padding()
//                    
//                    Spacer()
                    
                    HStack {
                        VStack {
                            Text("1.6k")
                                .bold()
                                .font(.system(size: 20))
                                .padding(10)
                                .padding(.horizontal, 15)
                                .frame(width: geometry.size.width / 3.5, height: geometry.size.height / 6.5)
                                .background(Color.black)
                        }
                        .frame(width: geometry.size.width / 3.5, height: geometry.size.height / 6.5)
                        
                        Spacer()
                        
                        if self.best1600m != nil {
                            
                            VStack {
                                Spacer()
                                Text("\(UnitFormatter.secondsToTraditionalFormatString(seconds: self.best1600m!.timeInSeconds!.doubleValue))")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                                Text("Best Time")
                                    .bold()
                                    .font(.system(size: 15))
                            }
                            .padding()
                            Spacer()
                            VStack {
                                Spacer()
                                Text("\(self.avgTime1600m)")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                                Text("Avg. Time")
                                    .bold()
                                    .font(.system(size: 15))
                            }
                            .padding()
                            
                            
                        } else {
                            VStack (alignment: .center, spacing: 0) {
                                Spacer()
                                Text("No 1600m")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                            }
                            .padding()
                            
                            
                            
                            
                        }
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .frame(width: geometry.size.width / 1.1, height: geometry.size.height / 6.5)
                    .background(Color.blue)
                    .cornerRadius(15)
                    
                    
                    
                    Spacer()
                    
                    HStack {
                        VStack {
                            Text("5k")
                                .bold()
                                .font(.system(size: 20))
                                .padding(10)
                                .padding(.horizontal, 15)
                                .frame(width: geometry.size.width / 3.5, height: geometry.size.height / 6.5)
                                .background(Color.black)
                        }
                        .frame(width: geometry.size.width / 3.5, height: geometry.size.height / 6.5)
                        
                        Spacer()
                        if self.best5k != nil {
                            VStack {
                                Spacer()
                                Text("\(UnitFormatter.secondsToTraditionalFormatString(seconds: self.best5k!.timeInSeconds!.doubleValue))")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                                Text("Best Time")
                                    .bold()
                                    .font(.system(size: 15))
                            }
                            .padding()
                            Spacer()
                            VStack {
                                Spacer()
                                Text("\(UnitFormatter.pace(timeInSecs: self.best5k!.timeInSeconds!.doubleValue, distance: distanceMeasurements["5 km"]!, unit: self.distanceUnits))")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                                Text("Best Pace")
                                    .bold()
                                    .font(.system(size: 15))
                            }
                            .padding()
                        } else {
                            VStack (alignment: .center, spacing: 0) {
                                Spacer()
                                Text("No 5k")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                            }
                            .padding()
                        }
                        
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .frame(width: geometry.size.width / 1.1, height: geometry.size.height / 6.5)
                    .background(Color.yellow)
                    .cornerRadius(15)
                    
                    
                    Spacer()
                    
                    HStack {
                        VStack {
                            Text("10k")
                                .bold()
                                .font(.system(size: 20))
                                .padding(10)
                                .padding(.horizontal, 15)
                                .frame(width: geometry.size.width / 3.5, height: geometry.size.height / 6.5)
                                .background(Color.black)
                        }
                        .frame(width: geometry.size.width / 3.5, height: geometry.size.height / 6.5)
                        
                        Spacer()
                        
                        if self.best5k != nil {
                            VStack {
                                Spacer()
                                Text("\(UnitFormatter.secondsToTraditionalFormatString(seconds: self.best10k!.timeInSeconds!.doubleValue))")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                                Text("Best Time")
                                    .bold()
                                    .font(.system(size: 15))
                            }
                            .padding()
                            Spacer()
                            VStack {
                                Spacer()
                                Text("\(UnitFormatter.pace(timeInSecs: self.best5k!.timeInSeconds!.doubleValue, distance: distanceMeasurements["10 km"]!, unit: self.distanceUnits))")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                                Text("Best Pace")
                                    .bold()
                                    .font(.system(size: 15))
                            }
                            .padding()
                        } else {
                            VStack (alignment: .center, spacing: 0) {
                                Spacer()
                                Text("No 10k")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                            }
                            .padding()
                        }
                        
                        
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .frame(width: geometry.size.width / 1.1, height: geometry.size.height / 6.5)
                    .background(Color.green)
                    .cornerRadius(15)
                    
                    Spacer()
                    filterPicker(options: timeRanges, selectedOption: self.$defaultTimeRangeIndex)
                    
                    
                    
                }.navigationBarTitle("Profile")
                    .navigationBarItems(trailing: NavigationLink(destination: SettingsMenuView()) {
                        HStack {
                            Image(systemName: "ellipsis.circle.fill").font(.system(size: 28)).foregroundColor(.black)
                        }
                    })
            }
        }.onAppear {
            self.distanceUnits = availableDistanceUnits[UserDefaults.standard.integer(forKey: "Distance Units Index")]
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        return ProfileView()
    }
}
