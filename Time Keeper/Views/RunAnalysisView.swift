//
//  RunAnalysisView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 7/8/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct RunAnalysisView: View {
    var run : Record
    
    var body: some View {
        VStack {
            Text("Graph goes here")
//            Text(run.time)
//            Text(run.date)
        }
            .navigationBarTitle(Text("Analysis"), displayMode: .inline)

    }
}

struct RunAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        RunAnalysisView(run: Record())
    }
}
