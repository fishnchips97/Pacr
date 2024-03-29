//
//  LeaderboardView.swift
//  Pacr
//
//  Created by Erik Fisher on 1/21/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI


let orderingOptions = ["Time", "Date"]
let timeRanges = ["Recent", "All"]

struct LeaderboardView: View {
    
    @FetchRequest(fetchRequest: Record.getAllRecords()) var records:FetchedResults<Record>
        @Environment(\.managedObjectContext) var moc
    
    @State private var orderOptionIndex: Int = 0
    @State private var defaultTimeRangeIndex: Int = 0
    @State private var defaultDistanceIndex: Int = 0
    @State private var isShowingRunAnalysis = false
    private var sortedRecords : [Record] {
        var result = Array(records).filter { (record) -> Bool in
            if timeRanges[defaultTimeRangeIndex] == "3 Months" {
                let threeMonthsInSeconds = 2592000.0
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
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    
                    HStack {
                        Text("\(distances[self.defaultDistanceIndex])")
                            .font(.title)
                            .padding(.leading, 20.0)
                        Spacer()
                    }
                    Spacer()
                    
                    
                    
                    if self.sortedRecords.count > 0 {
                        
                        HStack {
                            Text("Time")
                                .font(.system(size: 20))
                                .bold()
                                .padding(.leading, 20)
                            Spacer()
                            Text("Date")
                                .font(.system(size: 20))
                                .bold()
                                .padding(.trailing, 20)
                        }
                        List {
                            
                            
                            ForEach (self.sortedRecords) { record in
                                NavigationLink (destination: RunAnalysisView(run: record, runs: self.sortedRecords), isActive: self.$isShowingRunAnalysis) {
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
                            .onDelete(perform: self.deleteItems)
                            
                        }
                        .frame(height: geometry.size.height/1.7)
                    } else {
                        VStack {
                            Text("Runs will show up here")
                                .bold()
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height/1.5)
                    }
                    Spacer()
                    
                    HStack {
                        buttonTogglePicker(options: distances, selectedOption: self.$defaultDistanceIndex, width: geometry.size.width / 3.3)
                        
                        buttonTogglePicker(options: timeRanges, selectedOption: self.$defaultTimeRangeIndex, width: geometry.size.width / 3.3)
                        
                        buttonTogglePicker(options: orderingOptions, selectedOption: self.$orderOptionIndex, width: geometry.size.width / 3.3)
                        
                    }
                    Spacer()
                    
                }
                .navigationBarTitle("Leaderboard")
            .navigationBarItems(trailing: EditButton())
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        for offset in offsets {
            let record = records[offset]
            moc.delete(record)
        }
        try? moc.save()
    }
}

struct buttonTogglePicker: View {
    let options: [String]
    @Binding var selectedOption: Int
    let width: CGFloat
    var body: some View {
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
