//
//  ContentView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 1/11/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var tracker = DistanceTimeTracker()
    //    @FetchRequest(fetchRequest: Record.getAllRecords()) var records:FetchedResults<Record>
    
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var currentTab = 0
    
    
    var body: some View {
        TabView(selection: self.$currentTab) {
            //        TabView {
            
            LeaderboardView()
//                .environment(\.managedObjectContext, self.managedObjectContext)
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Leaderboard")
            }
            .tag(0)
            
            RecordingView(tracker: self.tracker)
                //                .environment(\.managedObjectContext, self.managedObjectContext)
                //        .blur(radius: CGFloat(self.trackBlur))
                //        .navigationBarHidden(false)
                //        .navigationBarTitle("TrackKeeper")
                .tabItem {
                    Image(systemName: "hare")
                    Text("Run")
            }
            .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
            }
            .tag(2)
        }
        //        .navigationBarHidden(true)
        //        .edgesIgnoringSafeArea([.top, .bottom])
        
        
        
    }
}



struct AppView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var previews: some View {
        AppView().environment(\.managedObjectContext, context)
    }
}
