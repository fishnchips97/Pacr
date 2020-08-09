//
//  CheckeredFinishLineView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 7/23/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

/// Credit to Paul Hudson, @twostraws September 18th 2019
/// From https://www.hackingwithswift.com/quick-start/swiftui/how-to-draw-a-checkerboard
struct CheckeredRectangle: Shape {
    
    let rows: Int
    let columns: Int
    let even: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let rowSize = rect.height / CGFloat(rows)
        let columnSize = rect.width / CGFloat(columns)
        
        for row in 0 ..< rows {
            for column in 0 ..< columns {
                if even {
                    let startX = columnSize * CGFloat(column)
                    let startY = rowSize * CGFloat(row)
                    if (row + column).isMultiple(of: 2) {
                        let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                        path.addRect(rect)
                    }
                } else {
                    let startX = columnSize * CGFloat(column)
                    let startY = rowSize * CGFloat(row)
                    if (row + column) % 2 == 1 {
                        let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                        path.addRect(rect)
                    }
                }
            }
        }
        return path
     }
}

struct CheckeredFinishLineView_Previews: PreviewProvider {
    static var previews: some View {
        CheckeredRectangle(rows: 2, columns: 5, even: true)
            .frame(width: 300, height: 400)
    }
}
