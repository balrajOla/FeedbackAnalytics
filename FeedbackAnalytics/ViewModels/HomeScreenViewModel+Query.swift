//
//  HomeScreenViewModel+Query.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 16/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit

extension HomeScreenViewModel {
  public func feedbackDetailsGroupedByPlatform(feedbackDetails: Promise<[FeedbackItem]>)
    -> (_ between: (startDate: Int64, endDate: Int64))
    -> Promise<[String : [FeedbackItem]]> {
      return { (between: (startDate: Int64, endDate: Int64)) -> Promise<[String : [FeedbackItem]]> in
        return feedbackDetails
          .map(on: DispatchQueue.global(qos: .utility)) { (response: [FeedbackItem]) -> [String : [FeedbackItem]] in
            return response
              |> ((between
                |> FeedbackQuery.filterByDate)
                >>>= FeedbackQuery.groupByPlatform().run).run
        }
      }
  }
  
  public func feedbackDetailsGroupedByRating(feedbackDetails: Promise<[FeedbackItem]>)
    -> (_ between: (startDate: Int64, endDate: Int64))
    -> Promise<[Int : [FeedbackItem]]> {
      return { (between: (startDate: Int64, endDate: Int64)) -> Promise<[Int : [FeedbackItem]]> in
        return feedbackDetails
          .map(on: DispatchQueue.global(qos: .utility)) { (response: [FeedbackItem]) -> [Int : [FeedbackItem]] in
            return response
              |> ((between
                |> FeedbackQuery.filterByDate)
                >>>= FeedbackQuery.groupByRating().run).run
        }
      }
  }
  
  public func feedbackDetailsGroupedByDates(feedbackDetails: Promise<[FeedbackItem]>)
    -> (_ between: (startDate: Int64, endDate: Int64))
    -> Promise<[Date : [FeedbackItem]]> {
      return { (between: (startDate: Int64, endDate: Int64)) -> Promise<[Date : [FeedbackItem]]> in
        return feedbackDetails
          .map(on: DispatchQueue.global(qos: .utility)) { (response: [FeedbackItem]) -> [Date : [FeedbackItem]] in
            return response
              |> ((between
                |> FeedbackQuery.filterByDate)
                >>>= FeedbackQuery.sortByCreatedDate().run
                >>>= FeedbackQuery.groupByCreatedDate().run).run
        }
      }
  }
  
  public func feedbackDetailsFilterByDates(feedbackDetails: Promise<[FeedbackItem]>)
    -> (_ between: (startDate: Int64, endDate: Int64))
    -> Promise<[FeedbackItem]> {
      return { (between: (startDate: Int64, endDate: Int64)) -> Promise<[FeedbackItem]> in
        return feedbackDetails
          .map(on: DispatchQueue.global(qos: .utility)) { (response: [FeedbackItem]) -> [FeedbackItem] in
            return response
              |> (between
                |> FeedbackQuery.filterByDate).run
        }
      }
  }
}
