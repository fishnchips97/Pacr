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
                            Text("Mile")
                                .bold()
                                .font(.system(size: 25))
                                .padding(10)
                                .padding(.horizontal, 15)
                                .frame(width: geometry.size.width / 4.2, height: geometry.size.height / 6.5)
                                .background(Color.black)
                            //                            Spacer()
                        }
                        .frame(width: geometry.size.width / 4.2, height: geometry.size.height / 6.5)
                        
                        Spacer()
                        
                        VStack {
                            Spacer()
                            Text("5:10")
                                .bold()
                                .font(.system(size: 25))
                            Spacer()
                            Text("Best Time")
                                .bold()
                                .font(.system(size: 20))
                        }
                        .padding()
                        Spacer()
                        VStack {
                            Spacer()
                            Text("5:40")
                                .bold()
                                .font(.system(size: 25))
                            Spacer()
                            Text("Avg. Time")
                                .bold()
                                .font(.system(size: 20))
                        }
                        .padding()
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .frame(width: geometry.size.width / 1.1, height: geometry.size.height / 6.5)
                    .background(Color.blue)
                    .cornerRadius(15)
                    
                    Spacer()
                    
                    HStack {
                        VStack {
                            Text("5k")
                                .bold()
                                .font(.system(size: 25))
                                .padding(10)
                                .padding(.horizontal, 15)
                                .frame(width: geometry.size.width / 4.2, height: geometry.size.height / 6.5)
                                .background(Color.black)
                            //                            Spacer()
                        }
                        .frame(width: geometry.size.width / 4.2, height: geometry.size.height / 6.5)
                        
                        Spacer()
                        
                        VStack {
                            Spacer()
                            Text("5:10")
                                .bold()
                                .font(.system(size: 25))
                            Spacer()
                            Text("Best Time")
                                .bold()
                                .font(.system(size: 20))
                        }
                        .padding()
                        Spacer()
                        VStack {
                            Spacer()
                            Text("5:40")
                                .bold()
                                .font(.system(size: 25))
                            Spacer()
                            Text("Avg. Time")
                                .bold()
                                .font(.system(size: 20))
                        }
                        .padding()
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .frame(width: geometry.size.width / 1.1, height: geometry.size.height / 6.5)
                    .background(Color.yellow)
                    .cornerRadius(15)
                    
                    
                    Spacer()
                    
                    HStack {
                        VStack {
                            Text("10k")
                                .bold()
                                .font(.system(size: 25))
                                .padding(10)
                                .padding(.horizontal, 15)
                                .frame(width: geometry.size.width / 4.2, height: geometry.size.height / 6.5)
                                .background(Color.black)
                            //                            Spacer()
                        }
                        .frame(width: geometry.size.width / 4.2, height: geometry.size.height / 6.5)
                        
                        Spacer()
                        
                        VStack {
                            Spacer()
                            Text("5:10")
                                .bold()
                                .font(.system(size: 25))
                            Spacer()
                            Text("Best Time")
                                .bold()
                                .font(.system(size: 20))
                        }
                        .padding()
                        Spacer()
                        VStack {
                            Spacer()
                            Text("5:40")
                                .bold()
                                .font(.system(size: 25))
                            Spacer()
                            Text("Avg. Time")
                                .bold()
                                .font(.system(size: 20))
                        }
                        .padding()
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .frame(width: geometry.size.width / 1.1, height: geometry.size.height / 6.5)
                    .background(Color.green)
                    .cornerRadius(15)
                    
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
