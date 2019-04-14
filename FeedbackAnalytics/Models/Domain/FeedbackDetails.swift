//
//  FeedbackDetails.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 14/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation

public struct FeedbackDetails {
  public let items: [FeedbackItem]
  
  public init(details: FeedbackDetailsResponse) {
    self.items = details.items.map(FeedbackItem.init(item:))
  }
}

public struct FeedbackItem {
  public let browser: String
  public let version: Float
  public let platform: String
  public let geoLocation: (lat: Double, lng: Double, city: String?)
  public let rating: Int
  public let labels: [String]
  public let createdDate: Int64
  
  private static let defaultVersion: Float = 0.0
  
  public init(item: Item) {
    self.browser = item.computedBrowser.browser
    self.version = Float(item.computedBrowser.version) ?? FeedbackItem.defaultVersion
    self.platform = item.computedBrowser.platform
    self.rating = item.rating
    self.labels = item.labels
    self.geoLocation = (lat: item.geo.lat, lng: item.geo.lon, city: item.geo.city)
    self.createdDate = item.creationDate
  }
}
