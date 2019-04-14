//
//  FeedbackQuery.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 14/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation

public class FeedbackQuery {
  public var dateRange: (startDate: Int64, endDate: Int64)?
  public var ratingRange: (startRating: Int, endRating: Int)?
  
  public init() {}
  
  public func setDateRange(startDate: Int64, endDate: Int64) {
    self.dateRange = (startDate: startDate, endDate: endDate)
  }
  
  public func setRatingRange(startRating: Int, endRating: Int) {
    self.ratingRange = (startRating: startRating, endRating: endRating)
  }
  
  public func getQuery() -> Reader<[FeedbackItem], [FeedbackItem]>? {
    let dateQuery = dateRange.map { range -> Reader<[FeedbackItem], [FeedbackItem]> in
      return filter(isIncluded: { item -> Bool in
        return (range.startDate <= item.createdDate) && (item.createdDate < range.endDate)
      }) }
    
    let ratingQuery = ratingRange.map { range -> Reader<[FeedbackItem], [FeedbackItem]> in
      return filter(isIncluded: { item -> Bool in
        return (range.startRating <= item.rating) && (item.rating < range.endRating)
      }) }
    
    return [dateQuery, ratingQuery]
      .compactMap {$0}
      .reduce(Reader<[FeedbackItem], [FeedbackItem]> { value in value }, { (result, value) -> Reader<[FeedbackItem], [FeedbackItem]> in
        result.map { value.run($0) }
      })
  }
}
