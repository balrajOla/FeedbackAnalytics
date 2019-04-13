//
//  Route.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import Alamofire

/**
 A list of possible requests that can be made for FeedbackAnalytics data.
 */
internal enum Route {
  case getFeedbackDetailRequest()
  
  internal var requestProperties:
    (method: HTTPMethod, path: String, query: [String: Any]) {
    switch self {
    case .getFeedbackDetailRequest():
      return (HTTPMethod.get, "/example/apidemo.json", [String: Any]())
    }
  }
}
