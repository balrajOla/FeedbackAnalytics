//
//  FeedbackDetails.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 14/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation

public struct FeedbackItem {
    public let browser: String
    public let version: Float
    public let platform: String
    public let geoLocation: (lat: Double, lng: Double, city: String?)
    public let rating: Int
    public let labels: [String]
    public let createdDate: Date
    
    private static let defaultVersion: Float = 0.0
    
    public init(item: Item) {
        self.browser = item.computedBrowser.browser
        self.version = Float(item.computedBrowser.version) ?? FeedbackItem.defaultVersion
        self.platform = joinAllWindowsPlatformVersion(item.computedBrowser.platform)
        self.rating = item.rating
        self.labels = item.labels
        self.geoLocation = (lat: item.geo.lat, lng: item.geo.lon, city: item.geo.city)
        self.createdDate = AppEnvironment.current.calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date(timeIntervalSince1970: TimeInterval(item.creationDate))) ?? AppEnvironment.current.dateType.init().date
    }
    
    private let joinAllWindowsPlatformVersion = { (platform: String) -> String in
        return (platform.lowercased().starts(with: "win") ? "Windows" : platform)
    }
}
