//
//  Double+RoundValue.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 18/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
