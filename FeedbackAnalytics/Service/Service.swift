//
//  Service.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit

public struct Service: ServiceType {
  public let serverConfig: ServerConfigType
  
  public init(serverConfig: ServerConfigType = ServerConfig.production) {
    self.serverConfig = serverConfig
  }
  
  public func fetchFeedbackDetails() -> Promise<FeedbackDetailsResponse> {
    return fetchFeedbackDetailsCache()
           .recover { _ -> Promise<FeedbackDetailsResponse> in
             return Route.getFeedbackDetailRequest()
                    |> self.request(route:)
                    |> self.decode(response:)
                    |> self.cache(response:)
          }
  }
}
