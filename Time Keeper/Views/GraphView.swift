//
//  GraphView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 7/13/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct GraphView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(0..<10) {_ in
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: 50, height: 200)
                        }
                    }
                }.frame(width: geometry.size.width - 50, height: geometry.size.height / 4 - 10)
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: 200))
                    path.addLine(to: CGPoint(x: 10, y: 200))
                    path.addLine(to: CGPoint(x: 10, y: 0))
                }
                .fill(Color.gray)
                .offset(x: 10, y: 0)
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 200))
                    path.addLine(to: CGPoint(x: 300, y: 200))
                    path.addLine(to: CGPoint(x: 300, y: 190))
                    path.addLine(to: CGPoint(x: 0, y: 190))
                }
                .fill(Color.green)
                .offset(x: 10, y: 0)
//                HStack {
//                    Rectangle()
//                        .fill(Color.green)
//                        .frame(width: 50, height: 100)
//
//
//
//                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height / 4)
            .border(Color.black)
            
            
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
