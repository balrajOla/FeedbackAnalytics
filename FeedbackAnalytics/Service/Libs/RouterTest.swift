//
//  RouterTest.swift
//  FeedbackAnalyticsUnitTests
//
//  Created by Balraj Singh on 07/06/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import XCTest
@testable import FeedbackAnalytics
import Alamofire

class RouterTest: XCTestCase {
    func test_Route_GetFeedbackDetailsRequest() {
        let feedbackDetailsRoute = Route.getFeedbackDetailRequest.requestProperties
        let feedbackDetailRequestPath = "/656eb85b5dca64bb640b9df841f691e3/raw/6f3e36c027687f4fd2bf3ab85de1d6e5faed8094/sample.json"
        
        XCTAssertEqual(feedbackDetailsRoute.method, HTTPMethod.get, "Feedback details API call should be a GET call")
        XCTAssertEqual(feedbackDetailsRoute.path, feedbackDetailRequestPath, "Feedback details API URL Changed")
        XCTAssertTrue(feedbackDetailsRoute.query.isEmpty)
    }
}
