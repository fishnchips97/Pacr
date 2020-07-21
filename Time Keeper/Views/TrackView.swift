//
//  TrackView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 6/8/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI

struct TrackView: View {
    
    @Binding var startAnimationTarget: Bool
    @Binding var startAnimationCurrent: Bool
    @Binding var currentPct: CGFloat
    @Binding var finishLinePct: CGFloat
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {

                TrackShape().stroke(Color.orange, style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                    .frame(width: proxy.size.width, height: proxy.size.height/2)
                /// finish line
                Rectangle()
                    .frame(width: 30, height: 10)
                    .offset(x: -15, y: -15)
                    .modifier(FollowEffect(pct: 0.0, path: TrackShape.createTrackPath(from: self.finishLinePct, rect: CGRect(x: 0, y: 0, width: proxy.size.width, height: proxy.size.height / 2)), rotate: false))

                /// target pace
                Circle().foregroundColor(Color.red)
                    .frame(width: 30, height: 30)
                    .offset(x: -15, y: -15)
                    .modifier(FollowEffect(pct: self.startAnimationTarget ? 1.0 : 0.0, path: TrackShape.createTrackPath(in: CGRect(x: 0, y: 0, width: proxy.size.width, height: proxy.size.height / 2)), rotate: true))
                
                /// current pace
                Circle().foregroundColor(Color.green)
                    .frame(width: 30, height: 30)
                    .offset(x: -15, y: -15)
                    .modifier(FollowEffect(pct: self.startAnimationCurrent ? 1.0 : 0.0, path: TrackShape.createTrackPath(from: self.currentPct, rect: CGRect(x: 0, y: 0, width: proxy.size.width, height: proxy.size.height / 2)), rotate: true))
                    

                }.frame(alignment: .topLeading)
        }
        .padding(20)
        
    }
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView(startAnimationTarget: .constant(false), startAnimationCurrent: .constant(false), currentPct: .constant(0.0), finishLinePct: .constant(0.0))
    }
}

struct TrackShape: Shape {
    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
//        path.closeSubpath()
//        return Capsule.path(Capsule())(in: rect)
//        return path
        return TrackShape.createTrackPath(in: rect)
    }
    
    static func createTrackPath(in rect: CGRect) -> Path {
        var path = Path()
        let distX = rect.maxX - rect.minX
        let distY = rect.maxY - rect.minY
        /// 0.43 is ratio of radius to straightaway from actual track dimensions
        let radius = distY * 0.4325157009
        let diameter = 2 * radius
        let diff = distX - diameter
        let offset = diff / 2
        
        let point1 = CGPoint(x: rect.minX + diameter + offset, y: rect.maxY)
        let point2 = CGPoint(x: rect.minX + diameter + offset, y: rect.minY)
        let point3 = CGPoint(x: rect.minX + offset, y: rect.maxY)
        
        path.move(to: point1)
        path.addLine(to: point2)
        path.addArc(center: CGPoint(x: rect.minX + radius + offset, y: rect.minY), radius: radius, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: true)
        path.addLine(to: point3)
        path.addArc(center: CGPoint(x: rect.minX + radius + offset, y: rect.maxY), radius: radius, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: true)
//        path.closeSubpath()
        
        return path
    }
    
    static func createTrackPath(from pct: CGFloat, rect: CGRect) -> Path {
        let wholePath = TrackShape.createTrackPath(in: rect)
        var firstPart = wholePath.trimmedPath(from: pct, to: 1)
        let secondPart = wholePath.trimmedPath(from: 0, to: pct)
        firstPart.addPath(secondPart)
        return firstPart
    }
}

struct Racer: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()
        
        return path
    }
}


/// geometry effect taken from swiftui-lab
/// Example 9 - https://gist.github.com/swiftui-lab/e5901123101ffad6d39020cc7a810798

struct FollowEffect: GeometryEffect {
    var pct: CGFloat = 0.5
    let path: Path
    var rotate = true

    var animatableData: CGFloat {
        get { return pct }
        set { pct = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {

        if !rotate {
            let pt = percentPoint(pct)

            return ProjectionTransform(CGAffineTransform(translationX: pt.x, y: pt.y))
        } else {
            // Calculate rotation angle, by calculating an imaginary line between two points
            // in the path: the current position (1) and a point very close behind in the path (2).
            let pt1 = percentPoint(pct)
            let pt2 = percentPoint(pct - 0.01)

            let a = pt2.x - pt1.x
            let b = pt2.y - pt1.y

            let angle = a < 0 ? atan(Double(b / a)) : atan(Double(b / a)) - Double.pi

            let transform = CGAffineTransform(translationX: pt1.x, y: pt1.y).rotated(by: CGFloat(angle))

            return ProjectionTransform(transform)
        }
    }

    func percentPoint(_ percent: CGFloat) -> CGPoint {

        let pct = percent > 1 ? 0 : (percent < 0 ? 1 : percent)

        let f = pct > 0.999 ? CGFloat(1-0.001) : pct
        let t = pct > 0.999 ? CGFloat(1) : pct + 0.001
        let tp = path.trimmedPath(from: f, to: t)

        return CGPoint(x: tp.boundingRect.midX, y: tp.boundingRect.midY)
    }
}
