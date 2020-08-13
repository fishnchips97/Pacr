//
//  ContentView.swift
//  Pacr
//
//  Created by Erik Fisher on 1/11/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var tracker = DistanceTimeTracker()
    @State var tortoiseOrHare: String = UserDefaults.standard.string(forKey: "Tortoise or Hare") ?? "hare"
    
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var currentTab = 0
    
    
    var body: some View {
        TabView(selection: self.$currentTab) {
            
            LeaderboardView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Leaderboard")
            }
            .tag(0)
            
            RecordingView(tracker: self.tracker)
                .tabItem {
                    Image(systemName: self.tortoiseOrHare)
                    Text("Run")
            }
            .tag(1)
            
            ProfileView(tortoiseOrHare: self.$tortoiseOrHare)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
            }
            .tag(2)
        }
        .accentColor(.green)
        
        
        
    }
}



struct AppView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var previews: some View {
        AppView().environment(\.managedObjectContext, context)
    }
}
