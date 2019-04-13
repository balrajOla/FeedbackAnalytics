//
//  ServerConfig.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation

/**
 A type that knows the location of a FeedbackAnalytics API.
 */
public protocol ServerConfigType {
  var apiBaseUrl: URL { get }
  var environment: EnvironmentType { get }
}

public enum EnvironmentType: String {
  case production = "Production"
}

public struct ServerConfig: ServerConfigType {
  public fileprivate(set) var apiBaseUrl: URL
  public fileprivate(set) var environment: EnvironmentType
  
  public static let production: ServerConfigType = ServerConfig(
    apiBaseUrl: URL(string: "https://\(Secrets.Api.Endpoint.production)")!,
    environment: EnvironmentType.production
  )
}

public enum Secrets {
  public enum Api {
    public enum Endpoint {
      public static let production = "http://cache.usabilla.com"
    }
  }
}
