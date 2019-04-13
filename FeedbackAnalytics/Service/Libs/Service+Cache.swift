//
//  Service+Cache.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit

extension Service {
  public func fetchFeedbackDetailsCache() -> Promise<FeedbackDetailsResponse> {
    return DispatchQueue
      .global(qos: .utility)
      .async(PMKNamespacer.promise) { () throws -> FeedbackDetailsResponse in
        guard let cacheValue = (AppEnvironment.current.cache[FACache.fa_feedbackDetailsResponse] as? FeedbackDetailsResponse) else {
          throw FACacheError.noValueFound
        }
        
        return cacheValue
    }
  }
  
  public func cache<T>(response: Promise<T>) -> Promise<T> {
    return response.tap(on: DispatchQueue.global(qos: .utility)) {
      _  = $0.map { AppEnvironment.current.cache[FACache.fa_feedbackDetailsResponse] = $0 }
    }
  }
}
