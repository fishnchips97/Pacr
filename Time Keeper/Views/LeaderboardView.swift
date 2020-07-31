//
//  LeaderboardView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 1/21/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI


let orderingOptions = ["Time", "Date"]
let timeRanges = ["Recent", "All"]

struct LeaderboardView: View {
    
    @FetchRequest(fetchRequest: Record.getAllRecords()) var records:FetchedResults<Record>
//    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var orderOptionIndex: Int = 0
    @State private var defaultTimeRangeIndex: Int = 0
    @State private var defaultDistanceIndex: Int = 0
    private var sortedRecords : [Record] {
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
            record.distance?.description ?? "" == distances[defaultDistanceIndex]
        }
        if orderingOptions[orderOptionIndex] == "Time" {
            result.sort {
                return $0.timeInSeconds?.decimalValue ?? 0 < $1.timeInSeconds?.decimalValue ?? 0
            }
        } else if orderingOptions[orderOptionIndex] == "Date" {
            result.sort {
                return $0.dateRecorded ?? Date() > $1.dateRecorded ?? Date()
            }
        }
        return result
//        return [Record]()
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
            VStack {
            
                HStack {
                        Text("\(distances[self.defaultDistanceIndex])")
                            .font(.title)
                            .multilineTextAlignment(.leading)
                            .padding([.top, .leading], 20.0)
                        Spacer()
                    }
                Spacer()
                    
                    
                    
                    if self.sortedRecords.count > 0 {
                        VStack {
                            List {
                                HStack {
                                    Text("Time").font(.system(size: 20)).bold()
                                    Spacer()
                                    Text("Date").font(.system(size: 20)).bold()
                                }
                                
                                ForEach (self.sortedRecords) { record in
                                    NavigationLink (destination: RunAnalysisView(run: record, runs: self.sortedRecords)) {
                                        HStack {
                                            if orderingOptions[self.orderOptionIndex] == "Time" {
                                                Text("\((self.sortedRecords.firstIndex(of: record) ?? 0) + 1).").font(.system(size: 20))
                                                    .bold()
                                            }
                                            Text("\(UnitFormatter.secondsToTraditionalFormatString(seconds: record.timeInSeconds!.doubleValue))")
                                                .font(.system(size: 20))
                                                .bold()
                                            Spacer()
                                            Text("\(UnitFormatter.dateToString(date: record.dateRecorded))")
                                        }
                                    }
                                    
                                }
                                
                            }
                        }
                        .frame(height: geometry.size.height/1.5)
                    } else {
                        VStack {
                            Text("Runs will show up here")
                            .bold()
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height/1.5)
                    }
                    Spacer()
                    
                    HStack {
//                        Spacer().frame(height: 24)
                        buttonTogglePicker(options: distances, selectedOption: self.$defaultDistanceIndex, width: geometry.size.width / 3.3)
                            
                        buttonTogglePicker(options: timeRanges, selectedOption: self.$defaultTimeRangeIndex, width: geometry.size.width / 3.3)
                            
                        buttonTogglePicker(options: orderingOptions, selectedOption: self.$orderOptionIndex, width: geometry.size.width / 3.3)
                            
//                        Spacer().frame(height: 24)
                    }
                Spacer()
                    
                }.navigationBarTitle("Leaderboard")
            }
        }
        
        
            
            
        
    }
}

struct buttonTogglePicker: View {
    let options: [String]
    @Binding var selectedOption: Int
    let width: CGFloat
    var body: some View {
//        Picker("Option Picker", selection: $selectedOption) {
//            ForEach(0 ..< options.count) { index in
//                Text(self.options[index]).tag(index)
//            }
//        }
//        .pickerStyle(SegmentedPickerStyle())
//        .padding(.horizontal, 10)
//        .padding(.bottom, 10)
        Button(action: {
            let nextIndex = self.options.index(after: self.selectedOption)
            self.selectedOption = self.options.endIndex > nextIndex ? nextIndex : self.options.startIndex
        }) {
            Text("\(self.options[self.selectedOption])")
            .bold()
        }
        .padding()
        .frame(width: self.width)
        .background(Color.green)
        .cornerRadius(15)
        .foregroundColor(Color.white)
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
