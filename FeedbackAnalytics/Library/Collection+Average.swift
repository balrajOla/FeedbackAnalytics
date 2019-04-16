//
//  Collection+Average.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 16/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
extension Collection where Element: Numeric {
  /// Returns the total sum of all elements in the array
  var total: Element { return reduce(0, +) }
}

extension Collection where Element: BinaryInteger {
  /// Returns the average of all elements in the array
  var average: Double {
    return isEmpty ? 0 : Double(total) / Double(count)
  }
}

extension Collection where Element: BinaryFloatingPoint {
  /// Returns the average of all elements in the array
  var average: Element {
    return isEmpty ? 0 : total / Element(count)
  }
}
