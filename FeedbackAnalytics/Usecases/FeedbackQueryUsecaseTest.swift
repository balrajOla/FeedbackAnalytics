//
//  FeedbackQueryUsecaseTest.swift
//  FeedbackAnalyticsUnitTests
//
//  Created by Balraj Singh on 07/06/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import XCTest
import PromiseKit
@testable import FeedbackAnalytics

class FeedbackQueryUsecaseTest: XCTestCase {
    
    func test_FeedbackQuery_GroupByPlatform() {
        // prepare test data
        let platforWindows = "Windows"
        let platforMac = "Mac"
        let windowsPlatformMockData = generateRandomFeedbackItems(forPlatform: platforWindows)
        let macPlatformMockData = generateRandomFeedbackItems(forPlatform: platforMac)
        let finalMockData = macPlatformMockData + windowsPlatformMockData
        
        let groupedData = FeedbackQueryUsecase.groupByPlatform().run(finalMockData)
        
        if let windowsData = groupedData[platforWindows] {
            XCTAssertEqual(windowsData, windowsPlatformMockData, "Windows Mock data is not the same")
        } else {
            XCTAssert(false, "Groupby Platform should contain data for Windows Category")
        }
    }
    
    // Generate feedback items for a specific platform
    private func generateRandomFeedbackItems(forPlatform platform: String) -> [FeedbackItem] {
        return [1...100].map { _ -> FeedbackItem in
            return FeedbackItem(browser: "ABC",
                                version: 1.1,
                                platform: platform,
                                geoLocation: (lat: 1, lng: 1, city: nil),
                                rating: 1,
                                labels: [String](),
                                createdDate: Date.init()) }
    }
}

extension FeedbackItem: Equatable {
    public static func == (lhs: FeedbackItem, rhs: FeedbackItem) -> Bool {
        return lhs.platform == rhs.platform
            && lhs.browser == rhs.browser
            && lhs.createdDate == rhs.createdDate
            && lhs.geoLocation == rhs.geoLocation
            && lhs.labels == rhs.labels
    }
}
