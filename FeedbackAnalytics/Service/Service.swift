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
  
  private func decode<T: Decodable>(response: Promise<Data>) -> Promise<T> {
    return response.compactMap(on: DispatchQueue.global(qos: .utility)) { try JSONDecoder().decode(T.self, from: $0) }
  }
  
  //MARK: Private Cache Operations
  private func fetchFeedbackDetailsCache() -> Promise<FeedbackDetailsResponse> {
    return DispatchQueue
      .global(qos: .utility)
      .async(PMKNamespacer.promise) { () throws -> FeedbackDetailsResponse in
        guard let cacheValue = (AppEnvironment.current.cache[FACache.fa_feedbackDetailsResponse] as? FeedbackDetailsResponse) else {
          throw FACacheError.noValueFound
        }
        
        return cacheValue
    }
  }
  
  private func cache<T>(response: Promise<T>) -> Promise<T> {
    return response.tap(on: DispatchQueue.global(qos: .utility)) {
      _  = $0.map { AppEnvironment.current.cache[FACache.fa_feedbackDetailsResponse] = $0 }
    }
  }
}
