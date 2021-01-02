//
//  Array+NormalizedMagnitude.swift
//  RingChart
//
//  Created by Joshua Homann on 1/2/21.
//

import Foundation

extension Array where Element: BinaryFloatingPoint {
  var normalizedMagnitude: [Element] {
    guard let maximum = max(),
      let minimum = min() else {
      return self
    }
    let magnitude = Swift.max(abs(maximum), abs(minimum))
    guard !magnitude.isZero else {
      return self
    }
    return map { $0 / magnitude }
  }
}
