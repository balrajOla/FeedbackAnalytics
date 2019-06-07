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
        
        XCTAssertEqual(feedbackDetailsRoute.method, HTTPMethod.get, "Feedback details API call should be a GET call")
    }
}
