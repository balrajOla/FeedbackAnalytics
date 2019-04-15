//
//  FeedbackDetailsUsecase.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit

public struct FeedbackDetailsUsecase {
  public init() {}
  
  public func getFeedbackDetailsGroupedByPlatform(between: (startDate: Int64, endDate: Int64)) -> Promise<[String : [FeedbackItem]]> {
    return AppEnvironment.current.apiService.fetchFeedbackDetails()
      .map { (response: FeedbackDetailsResponse) -> [String : [FeedbackItem]] in
        return response.items.map { FeedbackItem(item: $0) }
          |> ((between
            |> FeedbackQuery.filterByDate) >>>= FeedbackQuery.groupByPlatform().run).run
    }
  }
  
  public func getFeedbackDetailsGroupedByRating(between: (startDate: Int64, endDate: Int64)) -> Promise<[Int : [FeedbackItem]]> {
    return AppEnvironment.current.apiService.fetchFeedbackDetails()
      .map { (response: FeedbackDetailsResponse) -> [Int : [FeedbackItem]] in
        return response.items.map { FeedbackItem(item: $0) }
          |> ((between
            |> FeedbackQuery.filterByDate) >>>= FeedbackQuery.groupByRating().run).run
    }
  }
  
  public func getFeedbackDetailsGroupedByDates(between: (startDate: Int64, endDate: Int64)) -> Promise<[Date : [FeedbackItem]]> {
    return AppEnvironment.current.apiService.fetchFeedbackDetails()
      .map { (response: FeedbackDetailsResponse) -> [Date : [FeedbackItem]] in
        return response.items.map { FeedbackItem(item: $0) }
          |> ((between
            |> FeedbackQuery.filterByDate) >>>= FeedbackQuery.groupByCreatedDate().run).run
    }
  }
}
