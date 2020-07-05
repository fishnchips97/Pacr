//
//  ContentView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 1/11/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
//    @FetchRequest(fetchRequest: Record.getAllRecords()) var records:FetchedResults<Record>
    
    @State var disableOverlay = false
    @State var overlayOpacity = 1.0
    @State var trackBlur = 5.0
    
//    @State var disableOverlay = true
//    @State var overlayOpacity = 0.0
//    @State var trackBlur = 0.0
    
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        ZStack {
            RecordingView(disableOverlay: self.$disableOverlay, overlayOpacity: self.$overlayOpacity, trackBlur: self.$trackBlur)
                .environment(\.managedObjectContext, self.managedObjectContext)
                .blur(radius: CGFloat(self.trackBlur))
                .overlay(
                    MainMenuView(
                        disableOverlay: self.$disableOverlay, overlayOpacity: self.$overlayOpacity, trackBlur: self.$trackBlur
                    )
                        .opacity(self.overlayOpacity)
                        .environment(\.managedObjectContext, self.managedObjectContext)
            )
            
        }
        
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
