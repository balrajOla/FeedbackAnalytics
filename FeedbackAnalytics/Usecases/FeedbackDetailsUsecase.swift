//
//  FeedbackDetailsUsecase.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 06/06/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit

public struct FeedbackDetailsUsecase {
  public init() {}
  
  public func getFeedbackDetails() -> Promise<[FeedbackItem]> {
    return AppEnvironment.current.apiService.fetchFeedbackDetails()
      .map(on: DispatchQueue.global(qos: .utility)) { (response: FeedbackDetailsResponse) -> [FeedbackItem] in
        return response.items.map { FeedbackItem(item: $0) }
    }
  }
}
