//
//  FeedbackQuery.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 14/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation

public struct FeedbackQuery {
  public static let filterByDate = { (dateRange: (startDate: Int64, endDate: Int64)) -> Reader<[FeedbackItem], [FeedbackItem]> in
    return filter(isIncluded: { item -> Bool in
      return (dateRange.startDate <= Int64(item.createdDate.timeIntervalSince1970)) && (Int64(item.createdDate.timeIntervalSince1970) < dateRange.endDate)
    })
  }
  
  public static let groupByPlatform = { () -> Reader<[FeedbackItem], [String : [FeedbackItem]]> in
    return groupBy(\FeedbackItem.platform)
  }
  
  public static let groupByBrowser = { () -> Reader<[FeedbackItem], [String : [FeedbackItem]]> in
    return groupBy(\FeedbackItem.browser)
  }
  
  public static let groupByNone = { () -> Reader<[FeedbackItem], [String : [FeedbackItem]]> in
    return Reader { value in ["None": value] }
  }
  
  public static let groupByCreatedDate = { () -> Reader<[FeedbackItem], [Date : [FeedbackItem]]> in
    return groupBy(\FeedbackItem.createdDate)
  }
  
  public static let groupByRating = { () -> Reader<[FeedbackItem], [Int : [FeedbackItem]]> in
    return groupBy(\FeedbackItem.rating)
  }
  
  public static let sortByCreatedDate = { () -> Reader<[FeedbackItem], [FeedbackItem]> in
    return sort(by: { (itemOne, itemSecond) -> Bool in
      return itemOne.createdDate < itemSecond.createdDate
    })
  }
}
