//
//  Path+Wedge.swift
//  RingChart
//
//  Created by Joshua Homann on 1/2/21.
//

import SwiftUI

extension Path {
  mutating func addWedge(
    in rect: CGRect,
    innerRadius: Double,
    outerRadius: Double,
    startAngle: Angle,
    endAngle: Angle
  ) {
    let center = CGPoint(x: rect.midX, y: rect.midY)
    move(
      to: CGPoint (
        x: center.x + CGFloat(cos(startAngle.radians)) * CGFloat(innerRadius),
        y: center.y + CGFloat(sin(startAngle.radians)) * CGFloat(innerRadius)
      )
    )
    addArc(
      center: center,
      radius: CGFloat(innerRadius),
      startAngle: startAngle,
      endAngle: endAngle,
      clockwise: false
    )
    addLine(
      to: CGPoint(
        x: center.x + CGFloat(cos(endAngle.radians)) * CGFloat(outerRadius),
        y: center.y + CGFloat(sin(endAngle.radians)) * CGFloat(outerRadius)
      )
    )
    addArc(
      center: center,
      radius: CGFloat(outerRadius),
      startAngle: endAngle,
      endAngle: startAngle,
      clockwise: true
    )
    closeSubpath()
  }
}

extension BinaryFloatingPoint {
  @inline(__always) static var τ: Self {
    2.0 * .pi
  }
}
