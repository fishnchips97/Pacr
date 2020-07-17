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
    //    @FetchRequest(fetchRequest: Record.getAllRecords()) var records:FetchedResults<Record>
    
    @State var overlayOpacity = 1.0
    @State var trackBlur = 5.0
    
    //    @State var disableOverlay = true
    //    @State var overlayOpacity = 0.0
    //    @State var trackBlur = 0.0
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView {
            
            LeaderboardView()
                .environment(\.managedObjectContext, self.managedObjectContext)
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Leaderboard")
                }
        
        
        RecordingView(overlayOpacity: self.$overlayOpacity, trackBlur: self.$trackBlur)
        .environment(\.managedObjectContext, self.managedObjectContext)
//        .blur(radius: CGFloat(self.trackBlur))
//        .navigationBarHidden(false)
//        .navigationBarTitle("TrackKeeper")
        .tabItem {
            Image(systemName: "hare")
            Text("Run")
        }
        
        ProfileView()
            .tabItem {
                Image(systemName: "person.circle")
                Text("Profile")
            }
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
