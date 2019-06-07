//
//  Service.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 06/06/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit

struct Service: ServiceType {
    let httpClient: HttpClientProtocol
    let cache: FeedbackDetailsCacheProtocol
    
    init(httpClient: HttpClientProtocol = HttClient(serverConfig: ServerConfig.production),
         cache: FeedbackDetailsCacheProtocol = FeedbackDetailsCache()) {
        self.httpClient = httpClient
        self.cache = cache
    }
    
    // method to get the feedback details and cache the value 
    func fetchFeedbackDetails() -> Promise<FeedbackDetailsResponse> {
        return cache.fetchFeedbackDetailsCache()
            .recover { _ -> Promise<FeedbackDetailsResponse> in
                return Route.getFeedbackDetailRequest
                    |> self.httpClient.request(route:)
                    |> self.decode(response:)
                    |> self.cache.cache(response:)
        }
    }
}
