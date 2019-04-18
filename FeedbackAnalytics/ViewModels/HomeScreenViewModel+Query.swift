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
    -> Promise<[String: [Date : [FeedbackItem]]]> {
      return { (between: (startDate: Int64, endDate: Int64)) -> Promise<[String: [Date : [FeedbackItem]]]> in
        return feedbackDetails
          .map(on: DispatchQueue.global(qos: .utility)) { (response: [FeedbackItem]) -> [String: [Date : [FeedbackItem]]] in
            return response
              |> ((between
                |> FeedbackQuery.filterByDate)
                >>>= FeedbackQuery.groupByPlatform().run
                >>=> FeedbackQuery.groupByCreatedDate().run).run
        }
      }
  }
  
  public func feedbackDetailsGroupedByBrowser(feedbackDetails: Promise<[FeedbackItem]>)
    -> (_ between: (startDate: Int64, endDate: Int64))
    -> Promise<[String: [Date : [FeedbackItem]]]> {
      return { (between: (startDate: Int64, endDate: Int64)) -> Promise<[String: [Date : [FeedbackItem]]]> in
        return feedbackDetails
          .map(on: DispatchQueue.global(qos: .utility)) { (response: [FeedbackItem]) -> [String: [Date : [FeedbackItem]]] in
            return response
              |> ((between
                |> FeedbackQuery.filterByDate)
                >>>= FeedbackQuery.groupByBrowser().run
                >>=> FeedbackQuery.groupByCreatedDate().run).run
        }
      }
  }
  
  public func feedbackDetailsGroupedByDates(feedbackDetails: Promise<[FeedbackItem]>)
    -> (_ between: (startDate: Int64, endDate: Int64))
    -> Promise<[String: [Date : [FeedbackItem]]]> {
      return { (between: (startDate: Int64, endDate: Int64)) -> Promise<[String: [Date : [FeedbackItem]]]> in
        return feedbackDetails
          .map(on: DispatchQueue.global(qos: .utility)) { (response: [FeedbackItem]) -> [String: [Date : [FeedbackItem]]] in
            return response
              |> ((between
                |> FeedbackQuery.filterByDate)
                >>>= FeedbackQuery.groupByNone().run
                >>=> FeedbackQuery.groupByCreatedDate().run).run
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
