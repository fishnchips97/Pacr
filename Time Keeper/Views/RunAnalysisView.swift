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
            DotGraphView(xData: [1, 2, 3], yData: [10, 20, 30], highlightData: 3)
            Text("\(run.distance!.description)")
            Text("\(run.time)")
            Text("\(run.date)")
            
//            Text("test")
            
        }
            .navigationBarTitle(Text("Analysis"), displayMode: .inline)

    }
}

struct RunAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        RunAnalysisView(run: Record())
    }
}
