//
//  ProfileView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 7/9/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var body: some View {
        NavigationView {
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                
                
            }.navigationBarTitle("Profile")
            .navigationBarItems(trailing: NavigationLink(destination: SettingsMenuView()) {
                HStack {
                    Image(systemName: "ellipsis.circle.fill").font(.system(size: 28)).foregroundColor(.black)
//                    Text("Edit").font(.system(size: 20))
                }
            })
        }
        
        
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
