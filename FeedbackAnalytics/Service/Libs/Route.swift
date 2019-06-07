//
//  Route.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 06/06/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import Alamofire

/**
 A list of possible requests that can be made for FeedbackAnalytics data.
 */
internal enum Route {
    case getFeedbackDetailRequest
    
    internal var requestProperties:
        (method: HTTPMethod, path: String, query: [String: Any]) {
        switch self {
        case .getFeedbackDetailRequest:
            return (HTTPMethod.get, "/656eb85b5dca64bb640b9df841f691e3/raw/6f3e36c027687f4fd2bf3ab85de1d6e5faed8094/sample.json", [String: Any]())
        }
    }
}
