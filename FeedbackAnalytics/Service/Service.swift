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
    
    init(httpClient: HttpClientProtocol = HttClient(serverConfig: ServerConfig.production)) {
        self.httpClient = httpClient
    }
    
    public func fetchFeedbackDetails() -> Promise<FeedbackDetailsResponse> {
        return fetchFeedbackDetailsCache()
            .recover { _ -> Promise<FeedbackDetailsResponse> in
                return Route.getFeedbackDetailRequest
                    |> self.httpClient.request(route:)
                    |> self.decode(response:)
                    |> self.cache(response:)
        }
    }
}
