//
//  SaveRunView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 5/31/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct SaveRunView: View {
    
    @Binding var isShowing : Bool
    
    var body: some View {
        VStack {
            Text("Save Time?")
            Text("Time: 5:30")
            Text("Distance: 1 Mile")

            HStack {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel")
                }
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Save")
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        
    }
}

struct SaveRunView_Previews: PreviewProvider {
    static var previews: some View {
        SaveRunView(isShowing: .constant(true))
    }
}
