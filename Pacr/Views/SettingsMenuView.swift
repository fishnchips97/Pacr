//
//  SettingsMenuView.swift
//  Pacr
//
//  Created by Erik Fisher on 1/21/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI
import AVFoundation

struct SettingsMenuView: View {
    @State var currentIcon = "AppIcon"
    @State var distanceUnits: UnitLength = availableDistanceUnits[UserDefaults.standard.integer(forKey: "Distance Units Index")]
    @State var trackPrecisionMode: Bool = UserDefaults.standard.bool(forKey: "Track Precision Mode Enabled")
    @State var buzzOn: Bool = !UserDefaults.standard.bool(forKey: "Buzz for lead change")
    @Binding var tortoiseOrHare: String
    @State var active = true
    
    var body: some View {
        
        
        List {
            HStack {
                Button(action: {
                    if let _ = UIApplication.shared.alternateIconName {
                        UIApplication.shared.setAlternateIconName(nil) { (error) in
                            if error != nil {
                                print(error ?? "error")
                            } else {
                                self.currentIcon = "AppIcon"
                            }
                        }
                    } else {
                        UIApplication.shared.setAlternateIconName("Dark") { (error) in
                            if error != nil {
                                print(error ?? "error")
                            }  else {
                                self.currentIcon = "Dark"
                            }
                        }
                    }
                }, label: {
                    Text("Toggle Icon")
                        .font(.system(size: 20))
                        .bold()
                    
                })
                
                Spacer()
                
                if UIApplication.shared.alternateIconName == nil {
                    Image(uiImage: UIImage(named: currentIcon) ?? UIImage())
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                } else {
                    Image(uiImage: UIImage(named: currentIcon) ?? UIImage())
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                
            }
            
            HStack {
                Button(action: {
                    let index = availableDistanceUnits.firstIndex(of: self.distanceUnits)
                    let nextIndex = availableDistanceUnits.endIndex == index! + 1 ? 0 : index! + 1
                    self.distanceUnits = availableDistanceUnits[nextIndex]
                    UserDefaults.standard.set(nextIndex, forKey: "Distance Units Index")
                }) {
                    Text("Distance Units")
                        .font(.system(size: 20))
                        .bold()
                }
                Spacer()
                Text(self.distanceUnits.symbol)
                    .bold()
            }
            
            HStack {
                Button(action: {
                    
                    let nextPrecisionModeSetting = !self.trackPrecisionMode
                    self.trackPrecisionMode = nextPrecisionModeSetting
                    UserDefaults.standard.set(nextPrecisionModeSetting, forKey: "Track Precision Mode Enabled")
                }) {
                    Text("Precision Display Mode")
                        .font(.system(size: 20))
                        .bold()
                }
                Spacer()
                Text(self.trackPrecisionMode ? "On" : "Off")
                    .bold()
            }
            
            HStack {
                Button(action: {
                    
                    let tortoiseOrHareString = self.tortoiseOrHare == "hare" ? "tortoise" : "hare"
                    self.tortoiseOrHare = tortoiseOrHareString
                    UserDefaults.standard.set(tortoiseOrHareString, forKey: "Tortoise or Hare")
                }) {
                    Text("Tortoise or Hare")
                        .font(.system(size: 20))
                        .bold()
                }
                Spacer()
                Text(self.tortoiseOrHare == "hare" ? "Hare" : "Tortoise")
                    .bold()
            }
            
            HStack {
                Button(action: {
                    
                    let tortoiseOrHareString = self.tortoiseOrHare == "hare" ? "tortoise" : "hare"
                    self.tortoiseOrHare = tortoiseOrHareString
                    UserDefaults.standard.set(tortoiseOrHareString, forKey: "Tortoise or Hare")
                }) {
                    Text("Tortoise or Hare")
                        .font(.system(size: 20))
                        .bold()
                }
                Spacer()
                Text(self.tortoiseOrHare == "hare" ? "Hare" : "Tortoise")
                    .bold()
            }
            
            HStack {
                Button(action: {
                    self.buzzOn.toggle()
                    UserDefaults.standard.set(self.buzzOn, forKey: "Buzz for lead change")
                }) {
                    Text("Buzz on lead change")
                        .font(.system(size: 20))
                        .bold()
                }
                Spacer()
                Text(self.buzzOn ? "On" : "Off")
                    .bold()
            }
            
        }
        .onAppear {
            if UIApplication.shared.alternateIconName == nil {
                self.currentIcon = "AppIcon"
            } else {
                self.currentIcon = "Dark"
            }
        }
        .navigationBarTitle(Text("Settings"), displayMode: .inline)
        
    }
}

struct SettingsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenuView(tortoiseOrHare: .constant("hare"))
    }
}
