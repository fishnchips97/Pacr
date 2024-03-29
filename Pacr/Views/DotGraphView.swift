//
//  GraphView.swift
//  Pacr
//
//  Created by Erik Fisher on 7/13/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct DotGraphView: View {
    
    @State var yData: [Double]
    var highlightData: Double = 0
    var stringFormatter: (Double, UnitLength) -> (String) = UnitFormatter.paceNumberToString
    var yDataUnit: UnitLength
    
    func ratio(elem: Double, list: [Double]) -> CGFloat {
        
        if list.max()! == list.min()! {
            return 0
        }
        
        let numerator = CGFloat(elem - list.min()!)
        let denominator = CGFloat(list.max()! - list.min()!)
        
        return numerator / denominator
    }
    
    let circleSize = 20
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 40) {
                        Rectangle()
                        .fill(Color.white)
                        .frame(width: 70)
                        ForEach(0 ..< self.yData.count) {y_i in
                            
                            VStack {
                                Spacer(minLength: (geometry.size.height - CGFloat(self.circleSize)) * self.ratio(elem: self.yData[y_i], list: self.yData))
                                
                                if self.highlightData == self.yData[y_i] {
                                    Circle()
                                    .fill(Color.green)
                                    .frame(width: 20, height: 20)
                                } else {
                                    Circle()
                                    .fill(Color.black)
                                    .frame(width: 20, height: 20)
                                }
                                
                                    
                                    
                                Spacer(minLength: (geometry.size.height - CGFloat(self.circleSize)) * (1 - self.ratio(elem: self.yData[y_i], list: self.yData)))
                            }
                            
                            .frame(height: geometry.size.height)
                            
                        }
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 20)
                    }.scaleEffect(x: -1, y: 1, anchor: .center)
                }
                .scaleEffect(x: -1, y: 1, anchor: .center)
                .frame(width: geometry.size.width, height: geometry.size.height - CGFloat(self.circleSize))
                .offset(x: 0, y: 0)
                
                Rectangle()
                    .opacity(0)
                    .frame(height: geometry.size.height - CGFloat(self.circleSize))
                    .border(Color.black)
                
                HStack {
                    
                    
                    ZStack {
                        Rectangle()
                        .fill(Color.white)
                        .frame(width: 75)
                        .opacity(0.75)
                        
                        VStack(alignment: .center) {
                            Text("\(self.stringFormatter(self.yData.min() ?? 0, self.yDataUnit))")
                            .font(.system(size: 18))
                            Spacer()
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 25, height: 3)
                            Spacer()
                            Text("\(self.stringFormatter(self.yData.max() ?? 1, self.yDataUnit))")
                            .font(.system(size: 18))
                            
                        }
                        .frame(width: 75, height: geometry.size.height - CGFloat(self.circleSize))
                        .border(Color.black)
                    }
                    Spacer()
                }
                .frame(width: geometry.size.width)
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            
            
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        DotGraphView(yData: [10, 20, 30], yDataUnit: .kilometers).frame(width: 400, height: 300)
    }
}
