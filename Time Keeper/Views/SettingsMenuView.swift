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
    var body: some View {
        NavigationView {
            
            VStack {
                Button(action: {
                    if let _ = UIApplication.shared.alternateIconName {
                        UIApplication.shared.setAlternateIconName(nil) { (error) in
                            if error != nil {
                                print(error ?? "error")
                            }
                        }
                    } else {
                        UIApplication.shared.setAlternateIconName("Dark") { (error) in
                            if error != nil {
                                print(error ?? "error")
                            }
                        }
                    }
                    
                    
                }, label: {Text("Dark Mode App Icon Toggle")})
            }.multilineTextAlignment(.center)
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenuView()
    }
}
