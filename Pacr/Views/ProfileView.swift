//
//  ProfileView.swift
//  Pacr
//
//  Created by Erik Fisher on 7/9/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @FetchRequest(fetchRequest: Record.getAllRecords()) var records:FetchedResults<Record>
    @State var distanceUnits: UnitLength = availableDistanceUnits[UserDefaults.standard.integer(forKey: "Distance Units Index")]
    @State var defaultTimeRangeIndex: Int = 0
    @State private var showingSettings = false
    @Binding var tortoiseOrHare: String
    var color: [Color] = [.blue, .red, .orange, .green]
    
    @Environment(\.colorScheme) var colorScheme
    
    
    
    
    
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
                    ForEach (0 ..< distances.count) { i in
                        VStack {
                            Spacer()
                            BestRunView(
                                timeRangeIndex: self.$defaultTimeRangeIndex,
                                records: Array(self.records),
                                distance: distances[i],
                                units: self.distanceUnits,
                                backgroundColor: self.color[i]
                            )
                                .frame(width: geometry.size.width / 1.1, height: geometry.size.height / 6)
                            
                        }.tag(i)
                        
                    }
                    Spacer(minLength: 20)
                    ZStack {
                        
                        List {
                            NavigationLink(destination: SettingsMenuView(tortoiseOrHare: self.$tortoiseOrHare), isActive: self.$showingSettings) {
                                Text("There should be a better way than using a list")
                            }
                        }
                        .frame(width: 1, height: 1)
                        
                        buttonTogglePicker(options: timeRanges, selectedOption: self.$defaultTimeRangeIndex, width: geometry.size.width / 3.3)
                        .padding(.bottom)
                        
                    }
                    
                    
                    
                    
                    
                }
                    
                .navigationBarTitle("Profile")
                .navigationBarItems(trailing: Button(action: {
                    self.showingSettings.toggle()
                }, label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                }))
            }
        }.onAppear {
            self.distanceUnits = availableDistanceUnits[UserDefaults.standard.integer(forKey: "Distance Units Index")]
        }
    }
}

struct BestRunView: View {
    
    @Binding var timeRangeIndex: Int
    @State var records: [Record]
    @State var distance: String
    @State var units: UnitLength
    @State var backgroundColor: Color
    
    @Environment(\.colorScheme) var colorScheme

    
    private var timeInSeconds: Double {
        self.bestRecord!.timeInSeconds!.doubleValue
    }
    
    private var bestRecord : Record? {
        fastestRecord(records: records, distance: distance)
    }
    
    private func fastestRecord(records: [Record], distance: String) -> Record? {
        
        
        var result = records.filter { (record) -> Bool in
            if timeRanges[timeRangeIndex] == "Recent" {
                let threeMonthsInSeconds = 2592000.0
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
    
    private var avgTimeForDistance : String {
        var result = Array(records).filter { (record) -> Bool in
            if timeRanges[timeRangeIndex] == "Recent" {
                let threeMonthsInSeconds = 2592000.0
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
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    Text(self.distance == "1600 m" ? "1.6 km" : self.distance)
                        .bold()
                        .font(.system(size: 18))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 5)
                        .frame(width: geometry.size.width / 3.7, height: geometry.size.height)
                        .background(self.colorScheme == .dark ? Color.white : Color.black)
                        .foregroundColor(self.colorScheme == .dark ? Color.black : Color.white)
                }
                
                
                Spacer()
                
                if self.bestRecord != nil {
                    
                    VStack {
                        Spacer()
                        Text("\(UnitFormatter.secondsToTraditionalFormatString(seconds: self.timeInSeconds))")
                            .bold()
                            .font(.system(size: 20))
                        
                        Text("Best Time")
                            .bold()
                            .font(.system(size: 15))
                        Spacer()
                    }
                    Spacer()
                    VStack {
                        Spacer()
                        Text("\(UnitFormatter.pace(timeInSecs: self.timeInSeconds, distance: distanceMeasurements[self.distance]!, unit: self.units))")
                            .bold()
                            .font(.system(size: 18))
                    
                        Text("Best Pace")
                            .bold()
                            .font(.system(size: 15))
                        Spacer()
                    }
                    
                    
                    
                } else {
                    VStack (alignment: .center, spacing: 0) {
                        Spacer()
                        Text("No \(self.distance)")
                            .bold()
                            .font(.system(size: 20))
                        Spacer()
                    }
                    .padding()
                    
                    
                    
                    
                }
                Spacer()
            }
            .foregroundColor(Color.white)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(self.backgroundColor)
            .cornerRadius(15)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        return ProfileView(tortoiseOrHare: .constant("hare"))
    }
}
