//
//  LeaderboardView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 1/21/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI



struct LeaderboardView: View {
    
    @FetchRequest(fetchRequest: Record.getAllRecords()) var records:FetchedResults<Record>
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var orderOptionIndex: Int = 0
    let orderingOptions = ["Fastest Pace", "Most Recent"]
    @State private var defaultTimeRangeIndex: Int = 0
    let timeRanges = ["3 Months", "All Time"]
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
        if orderingOptions[orderOptionIndex] == "Fastest Pace" {
            result.sort {
                return $0.timeInSeconds?.decimalValue ?? 0 < $1.timeInSeconds?.decimalValue ?? 0
            }
        } else if orderingOptions[orderOptionIndex] == "Most Recent" {
            result.sort {
                return $0.dateRecorded ?? Date() > $1.dateRecorded ?? Date()
            }
        }
        return result
    }
    
    var body: some View {
        VStack {
            
            
            HStack{
                
                Text("Leaderboard")
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding([.top, .leading], 20.0)
                Spacer()
            }
            HStack {
                Text("\(distances[defaultDistanceIndex])")
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .padding(.leading, 20.0)
                .padding(.top, 10.0)
                Spacer()
            }
            
            
            
            List {
                HStack {
                    Text("Time").font(.system(size: 20)).bold()
                    Spacer()
                    Text("Date").font(.system(size: 20)).bold()
                }
                
                ForEach (self.sortedRecords) { record in
                    
                    HStack {
                        if self.orderingOptions[self.orderOptionIndex] == "Fastest Pace" {
                            Text("\((self.sortedRecords.firstIndex(of: record) ?? 0) + 1).").font(.system(size: 20)).bold()
                        }
                        Text("\(record.time)").font(.system(size: 20)).bold()
                        Spacer()
                        Text("\(record.date)")
                    }
                }
                
            }
            VStack {
                Spacer().frame(height: 24)
                filterPicker(options: orderingOptions, selectedOption: $orderOptionIndex)
                filterPicker(options: timeRanges, selectedOption: $defaultTimeRangeIndex)
                filterPicker(options: distances, selectedOption: $defaultDistanceIndex)
                Spacer().frame(height: 24)
            }
            
        }
        
    }
}

struct filterPicker: View {
    let options: [String]
    @Binding var selectedOption: Int
    var body: some View {
        Picker("Option Picker", selection: $selectedOption) {
            ForEach(0 ..< options.count) { index in
                Text(self.options[index]).tag(index)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
