//
//  SettingsMenuView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 1/21/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct SettingsMenuView: View {
    //    @Environment(\.managedObjectContext) var managedObjectContext
    //    @FetchRequest(fetchRequest: Record.getAllRecords()) var records:FetchedResults<Record>
    @State var currentIcon = "AppIcon"
    @State var distanceUnits = UserDefaults.standard.string(forKey: "Distance Units")
    
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
                    self.distanceUnits = (self.distanceUnits == "Kilometers") ? "Miles" : "Kilometers"
                    UserDefaults.standard.set(self.distanceUnits, forKey: "Distance Units")
                }) {
                    Text("Distance Units")
                }
                Spacer()
                Text(self.distanceUnits ?? "Kilometers")
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
        SettingsMenuView()
    }
}
