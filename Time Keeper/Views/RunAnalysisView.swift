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
        GeometryReader { geometry in
            VStack (alignment: .leading, spacing: 0) {
                Text("\(self.run.distance!.description)")
                    .font(.system(size: 40))
                    .bold()
                    .padding()
                
                DotGraphView(xData: [1, 2, 3], yData: [10, 20, 30], highlightData: 3)
                    .frame(width: geometry.size.width - 30, height: 300)
                
                Spacer()
                Text("\(self.run.time) seconds")
                    .font(.system(size: 40))
                    .padding()
                Text("\(self.run.date)")
                    .font(.system(size: 20))
                    .padding()
                
                Spacer()
                    
                    //            Text("test")
                    
                    .navigationBarTitle(Text("Analysis"), displayMode: .inline)
            }
        }
        
    }
}

struct RunAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        RunAnalysisView(run: Record())
    }
}
