//
//  ColorGenerator.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 18/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import UIKit

public func generateRandomColor() -> UIColor {
  let randonMixValue = 0.8
  
  func randonColorNumber() -> Double {
    return Double(arc4random_uniform(255))/255
  }
  
  let color = UIColor(red: CGFloat((randonColorNumber() + randonMixValue)/2),
                      green: CGFloat((randonColorNumber() + randonMixValue)/2),
                      blue: CGFloat((randonColorNumber() + randonMixValue)/2),
                      alpha: 1)
  
  return color;
}
