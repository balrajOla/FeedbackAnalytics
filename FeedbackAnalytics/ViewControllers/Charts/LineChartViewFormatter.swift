//
//  LineChartViewFormatter.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 17/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import Charts

class LineChartViewFormatter:IAxisValueFormatter  {
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "MMM d"
    
    return dateFormatterPrint.string(from: Date.init(timeIntervalSince1970: TimeInterval(value)))
  }
}
