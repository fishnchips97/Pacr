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
    @State var defaultTimeRangeIndex: Int = 0
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        Spacer(minLength: geometry.size.width / 7)
                        
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
                        Spacer(minLength: geometry.size.width / 7)
                    }
                    .padding()
                    
                    Spacer()
                    
                    HStack {
                        VStack {
                            Text("5:10")
                            Text("Best Mile")
                                .bold()
                                .font(.system(size: 15))
                        }
                        .frame(width: geometry.size.width / 1.5, height: 40)
                        .padding()
                        .border(Color.blue)
                        .padding()
                    }
                    
                    HStack {
                        VStack {
                            Text("25:10")
                            Text("Best 5k")
                                .bold()
                                .font(.system(size: 15))
                        }
                        .frame(width: geometry.size.width / 1.5, height: 40)
                        .padding()
                        .border(Color.yellow)
                        .padding()
                    }
                    
                    HStack {
                        VStack {
                            Text("42:10")
                            Text("Best 10k")
                                .bold()
                                .font(.system(size: 15))
                        }
                        .frame(width: geometry.size.width / 1.5, height: 40)
                        .padding()
                        .border(Color.green)
                        .padding()
                    }
                    
                    Spacer()
                    filterPicker(options: timeRanges, selectedOption: self.$defaultTimeRangeIndex)
                    
                    
                    
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
