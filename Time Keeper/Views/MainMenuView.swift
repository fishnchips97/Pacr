//
//  MainMenuView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 1/21/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct MainMenuView: View {
    
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var disableOverlay: Bool
    @Binding var overlayOpacity: Double
    @Binding var trackBlur : Double
    @State var settingsPresented = false
//    @State var leaderboardPresented = false
    var body: some View {
        GeometryReader {
            geometry in
            
            VStack {
                HStack{
                    
                    Text("Timekeeper")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding([.top, .leading], 20.0)
                    Spacer()
                }
                Spacer()
                Spacer()
                Spacer()
                
                NavigationLink(destination: LeaderboardView().environment(\.managedObjectContext, self.managedObjectContext)) {
                    HStack {
                        Image(systemName: "star.circle.fill")
                        Text("Leaderboard")
                            .fontWeight(.bold)
                    }.padding()
                }
                    
                
                .disabled(self.disableOverlay)
                .frame(width: geometry.size.width / 2)
                .background(Color.blue)
                .cornerRadius(15)
                .foregroundColor(.white)
                
                
                Button(action: {
                    self.settingsPresented.toggle()
                }) {
                    HStack {
                        Image(systemName: "tortoise.fill")
                        Text("Settings")
                            .fontWeight(.bold)
                    }.padding()
                }
                .disabled(self.disableOverlay)
                .frame(width: geometry.size.width / 2)
                .background(Color.yellow)
                .cornerRadius(15)
                .foregroundColor(.white)
                .sheet(isPresented: self.$settingsPresented) {
                    SettingsMenuView().environment(\.managedObjectContext, self.managedObjectContext)
                }
                
                
                Button(action: {
                    withAnimation {
                        self.disableOverlay.toggle()
                        self.overlayOpacity = 0.0
                        self.trackBlur = 0.0
                    }
                }) {
                    HStack {
                        Image(systemName: "hare.fill")
                        Text("Start")
                            .fontWeight(.bold)
                    }.padding()
                    
                }
                .disabled(self.disableOverlay)
                .frame(width: geometry.size.width / 2)
                .background(Color.green)
                .cornerRadius(15)
                .foregroundColor(.white)
                Spacer()
            }
        }
        
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(
            disableOverlay: .constant(false), overlayOpacity: .constant(0.5), trackBlur: .constant(0.5)
        )
    }
}
