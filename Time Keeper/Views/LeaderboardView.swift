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
    
    @State private var defaultPeopleIndex: Int = 0
    let peopleOptions = ["Personal", "Friends"]
    @State private var defaultTimeRangeIndex: Int = 0
    let timeRanges = ["3 Months", "All Time"]
    @State private var defaultDistanceIndex: Int = 0
    let distances = ["1 Mile", "10 Km", "Half Marathon"]
    
    var body: some View {
        VStack {
            
            
            HStack{
                
                Text("Leaderboard")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding([.top, .leading], 20.0)
                Spacer()
            }
            
            
            List {
                ForEach (0 ..< self.records.count) { index in
                    HStack {
                        Text("\(index + 1).").font(.system(size: 20)).bold()
                        Text("\(self.records[index].time)").font(.system(size: 20)).bold()
                        Spacer()
                        Text("\(self.records[index].date)")
                    }
                }
                
            }
            VStack {
                Spacer().frame(height: 24)
                filterPicker(options: peopleOptions, selectedOption: $defaultPeopleIndex)
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
