//
//  ContentView.swift
//  Shared
//
//  Created by Joshua Homann on 1/2/21.
//

import SwiftUI

struct RingChart: Shape, Animatable {
  private let values: [Double]
  private var proportion: Double
  var animatableData: Double {
    get { proportion }
    set { proportion = newValue }
  }
  init(values: [Double], proportion: Double = 1.0) {
    self.values = values.normalizedMagnitude
    self.proportion = proportion
  }

  func path(in rect: CGRect) -> Path {
    let fractionalWedgeCount = proportion * Double(values.count)
    let fullWedgeCount = Int(fractionalWedgeCount)
    let partialWedgeProportion = fullWedgeCount == .zero
      ? fractionalWedgeCount
      : fractionalWedgeCount.truncatingRemainder(dividingBy: Double(fullWedgeCount)) / fractionalWedgeCount
    let partialWedgeRadians = .τ * partialWedgeProportion
    let fullWedgeRadians = fullWedgeCount == 0
      ? .τ
      : (.τ - partialWedgeRadians) / Double(fullWedgeCount)
    let minorRadius = 0.25
    let minDimension = Double(min(rect.maxX, rect.maxY)) / 2
    return Path { path in
      values.prefix(fullWedgeCount).enumerated().forEach { offset, element in
        let index = Double(offset)
        path.addWedge(
          in: rect,
          innerRadius: minorRadius * minDimension,
          outerRadius: (element / (1 + minorRadius) + minorRadius) * minDimension,
          startAngle: .radians(index * fullWedgeRadians),
          endAngle: .radians((index + 1) * fullWedgeRadians)
        )
      }
      guard !partialWedgeRadians.isZero else {
        return
      }
      let startAngle = Angle(radians: Double(fullWedgeCount) * fullWedgeRadians)
      let endAngle = Angle(radians: startAngle.radians + partialWedgeRadians)
      path.addWedge(
        in: rect,
        innerRadius: minorRadius * minDimension,
        outerRadius: (values[fullWedgeCount] / (1 + minorRadius) +  minorRadius) * minDimension,
        startAngle: fullWedgeCount == 0 ? Angle(radians: .τ - endAngle.radians) : startAngle,
        endAngle: fullWedgeCount == 0 ? startAngle : endAngle)
    }
  }

}

struct ContentView: View {
  @State private var isToggled = true
  private let values = (0..<24).map { _ in Double.random(in: 0..<1000000) }
  var body: some View {
    VStack {
      GeometryReader { proxy in
        RingChart(values: values, proportion: isToggled ? 0 : 1)
          .scale(x: 1, y: -1, anchor: .center)
          .rotation(.radians( .τ / -4))
          .fill(RadialGradient(
            gradient: Gradient(colors: [.red, .orange, .purple, .blue]),
              center: .center,
              startRadius: 0,
              endRadius: min(proxy.size.width, proxy.size.height) / 2
          ))
          .drawingGroup()
      }
      Button("Push me") {
        withAnimation(Animation.linear(duration: 3)) {
          isToggled.toggle()
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      RingChart(values: [1,3,4,5,6,7.7,3], proportion: 0.3)
      RingChart(values: [1,3,4,5,6,7.7,3], proportion: 0.6)
      RingChart(values: [1,3,4,5,6,7.7,3], proportion: 0.7)
    }
  }
}
