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
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        VStack {
                            Text("100")
                            Text("Followers")
                                .bold()
                                .font(.system(size: 15))
                        }
                        .padding()
                        .frame(width: geometry.size.width / 4.1, height: 40)
                        .border(Color.black)
                        
                        
                        VStack {
                            Text("100")
                            Text("Following")
                                .bold()
                                .font(.system(size: 15))
                        }
                        .padding()
                        .frame(width: geometry.size.width / 4.1, height: 40)
                        .border(Color.black)
                        
                        VStack {
                            Text("5:10")
                            Text("Best Mile")
                                .bold()
                                .font(.system(size: 15))
                        }
                        .padding()
                        .frame(width: geometry.size.width / 4.1, height: 40)
                        .border(Color.black)
                    }
                    .padding()
                    Spacer()
                    Text("Best Times")
                    Spacer()
                    
                    
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
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
