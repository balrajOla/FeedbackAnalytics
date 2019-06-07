//
//  ServiceTest.swift
//  FeedbackAnalyticsUnitTests
//
//  Created by Balraj Singh on 07/06/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import XCTest
import PromiseKit
@testable import FeedbackAnalytics

class ServiceTest: XCTestCase {
    
    func test_Service_GetFeedbackDetailsRequest() {
        let mockHttpClient = HttpClientMock()
        let mockCache = CacheWithMissScenario()
        let service = Service(httpClient: mockHttpClient, cache: mockCache)
        
        _ = service.fetchFeedbackDetails()
            .tap { _ in
                if let httpClientRoute = mockHttpClient.route {
                    XCTAssertEqual(httpClientRoute, Route.getFeedbackDetailRequest, "Value should be equal")
                } else {
                    fatalError("Value cannot be nil")
                }
        }
    }
}

//MARK: MOCK CLASSES
class CacheWithMissScenario: FeedbackDetailsCacheProtocol {
    func fetchFeedbackDetailsCache() -> Promise<FeedbackDetailsResponse> {
        return Promise<FeedbackDetailsResponse>(error: FACacheError.noValueFound)
    }
    
    func cache<T>(response: Promise<T>) -> Promise<T> {
        return response
    }
}

class HttpClientMock: HttpClientProtocol {
    var route: Route?
    
    func request(route: Route) -> Promise<Data> {
        self.route = route
        
        return Promise<Data>(error: ServiceTestError.notImplement)
    }
}

enum ServiceTestError: Error {
    case notImplement
}

enum CacheTestError: Error {
    case missCache
}
