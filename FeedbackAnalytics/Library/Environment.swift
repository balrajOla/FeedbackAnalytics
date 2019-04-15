//
//  Environment.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation

/**
 A collection of **all** global variables and singletons that the app wants access to.
 */
public struct Environment {
  /// A type that exposes endpoints for fetching FeedbackAnalytics data.
  public let apiService: ServiceType
  
  /// A type that stored cached data
  public let cache: FACache
  
  /// A type that exposes how to capture dates as measured from # of seconds since 1970.
  public let dateType: DateProtocol.Type
  
  /// The user's calendar.
  public let calendar: Calendar
  
  public init(apiService: ServiceType = Service(),
              cache: FACache = FACache(),
              dateType: DateProtocol.Type = Date.self,
              calendar: Calendar = .current) {
    self.apiService = apiService
    self.cache = cache
    self.dateType = dateType
    self.calendar = calendar
  }
}
