//
//  FeedbackDetailsResponse.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation

public struct FeedbackDetailsResponse: Codable {
  public let items: [Item]
  public let count: Int
  public let total: Int
  public let countNolimit: Int
  private enum CodingKeys: String, CodingKey {
    case items
    case count
    case total
    case countNolimit = "count_nolimit"
  }
}

public struct Item: Codable {
  public let rating: Int
  public let ip: String
  public let labels: [String]
  public let status: String
  public let host: URL
  public let computedBrowser: ComputedBrowser
  public let tags: [String]
  public let creationDate: Int64
  public let browser: Browser
  public let geo: Geo
  public let id: String
  public let comments: [Comment]?
  
  private enum CodingKeys: String, CodingKey {
    case rating
    case ip
    case labels
    case status
    case host
    case computedBrowser = "computed_browser"
    case tags
    case creationDate = "creation_date"
    case browser
    case geo
    case id
    case comments
  }
}

public struct ComputedBrowser: Codable {
  public let version: String
  public let browser: String
  public let platform: String
  public let fullBrowser: String
  private enum CodingKeys: String, CodingKey {
    case version = "Version"
    case browser = "Browser"
    case platform = "Platform"
    case fullBrowser = "FullBrowser"
  }
}

public struct Images: Codable {
  public struct Screenshot: Codable {
    public let url: URL
    public let width: Int
    public let uri: String
    public let height: Int
  }
  public let screenshot: Screenshot
  public struct Detail: Codable {
    public let url: URL
    public let width: Int
    public let uri: String
    public let height: Int
  }
  public let detail: Detail
  public struct Cropped: Codable {
    public let url: URL
    public let width: Int
    public let uri: String
    public let height: Int
  }
  public let cropped: Cropped
  public struct List: Codable {
    public let url: URL
    public let width: Int
    public let uri: String
    public let height: Int
  }
  public let list: List
  public struct Thumbnail: Codable {
    public let url: URL
    public let width: Int
    public let uri: String
    public let height: Int
  }
  public let thumbnail: Thumbnail
  public struct Grid: Codable {
    public let url: URL
    public let width: Int
    public let uri: String
    public let height: Int
  }
  public let grid: Grid
  public struct FullImage: Codable {
    public let url: URL
    public let width: Int
    public let uri: String
    public let height: Int
  }
  public let fullImage: FullImage?
  public struct NoContext: Codable {
    public let url: URL
    public let width: Int
    public let uri: String
    public let height: Int
  }
  public let noContext: NoContext?
  private enum CodingKeys: String, CodingKey {
    case screenshot
    case detail
    case cropped
    case list
    case thumbnail
    case grid
    case fullImage = "full_image"
    case noContext = "no_context"
  }
}
public struct Timing: Codable {
  public let responseStart: Date
  public let redirectEnd: Int
  public let loadEventStart: Date
  public let domainLookupEnd: Date
  public let fetchStart: Date
  public let domainLookupStart: Date
  public let loadEventEnd: Date
  public let domInteractive: Date
  public let connectStart: Date
  public let requestStart: Date
  public let unloadEventEnd: Int
  public let domContentLoadedEventEnd: Date
  public let responseEnd: Date
  public let domComplete: Date
  public let redirectStart: Int
  public let connectEnd: Date
  public let domLoading: Date
  public let unloadEventStart: Int
  public let navigationStart: Date
  public let secureConnectionStart: Int
  public let domContentLoadedEventStart: Date
}
public struct Browser: Codable {
  public let onLine: Bool
  public let userAgent: String
  public let productSub: String?
  public let cookieEnabled: Bool
  public let product: String?
  public let appCodeName: String
  public let platform: String
  public let appName: String
  public let vendorSub: String?
  public let vendor: String?
  public let language: String?
  public let appVersion: String
  public let doNotTrack: String?
  public let buildID: String?
  public let oscpu: String?
  public let msDoNotTrack: String?
  public let systemLanguage: String?
  public let appMinorVersion: String?
  public let browserLanguage: String?
  public let cpuClass: String?
  public let userLanguage: String?
  public let maxTouchPoints: Int?
  public let msPointerEnabled: Bool?
  public let msManipulationViewsEnabled: Bool?
  public let pointerEnabled: Bool?
  public let msMaxTouchPoints: Int?
  public let standalone: Bool?
}
public struct Geo: Codable {
  public let country: String
  public let region: String?
  public let city: String?
  public let lat: Double
  public let lon: Double
  public let postalcode: String?
  public let area: String?
  public let metro: String?
}
public struct Custom: Codable {
  public let subject: String
}
public struct Viewport: Codable {
  public let width: Int
  public let height: Int
}
public struct Comment: Codable {
  public let id: String
  public let comment: String
  public struct CreationDate: Codable {
    public let sec: Date
    public let usec: Int
  }
  public let creationDate: CreationDate
  public let user: String
  private enum CodingKeys: String, CodingKey {
    case id
    case comment
    case creationDate = "creation_date"
    case user
  }
}
