//
//  HomeScreenViewModel.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 15/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import Charts
import PromiseKit

public enum FeedbackDetailsDataError: Error {
  case noData
}

public enum DataCategory: String {
  case none = "None"
  case platform = "Platform"
  case browser = "Browser"
}

public class HomeScreenViewModel {
  
  private let feedbackUsecase = FeedbackDetailsUsecase()
  
  private var defaultStartDate: Int64 = 1388534400
  private var defaultEndDate: Int64 = 1391745497
  private let defaultValue = 0
  
  public let splitByList = [DataCategory.none.rawValue, DataCategory.platform.rawValue, DataCategory.browser.rawValue]
  
  public func getFeedbackDetailsRatingPerDay(withLabel label: String,
                                             withSplitBy splitBy: DataCategory,
                                             with query: @escaping ([FeedbackItem]) -> Double) -> Promise<LineChartData> {
    let splitByFn = self.getSplitFunction(forSplit: splitBy)
    let feebackDetailsGroupByDate = self.feedbackUsecase.getFeedbackDetails()
                                    |> splitByFn
    
    return ((startDate: defaultStartDate, endDate: defaultEndDate)
      |> feebackDetailsGroupByDate)
      .map(on: DispatchQueue.global(qos: .utility)) { response -> LineChartData in
        guard response.count > 0 else {
          throw FeedbackDetailsDataError.noData
        }
        
        return response.mapValues {
          return $0.map { item -> (Date, Double) in
            return (item.key, query(item.value))
            }.sorted(by: { (valueOne, valueSecond) -> Bool in
              return valueOne.0 < valueSecond.0
            })
          }.reduce([String: [ChartDataEntry]]()) { (res, item) -> [String: [ChartDataEntry]] in
            var result = res
            result[item.key] = item.value.reduce([ChartDataEntry]()) { (res, item) -> [ChartDataEntry] in
              var result = res
              result.append(ChartDataEntry(x: item.0.timeIntervalSince1970, y: item.1))
              
              return result
            }
            return result
          }
          |> self.createLineChartData
    }
  }
  
  public func getAverageRatingForSelectedRange() -> Promise<Double> {
    return
      ((startDate: defaultStartDate, endDate: defaultEndDate)
        |> (self.feedbackUsecase.getFeedbackDetails()
          |> self.feedbackDetailsFilterByDates(feedbackDetails:)))
        .map{
          guard $0.count > 0 else {
            throw FeedbackDetailsDataError.noData
          }
          
          return ($0.map{ $0.rating }).average }
  }
  
  public func getBetweenDates() -> (startDate: Date, endDate: Date) {
    return (startDate: Date(timeIntervalSince1970: TimeInterval(self.defaultStartDate)), endDate: Date(timeIntervalSince1970: TimeInterval(self.defaultEndDate)))
  }
  
  public func setBetweenDate(startDate: Date, endDate: Date) {
    self.defaultStartDate = Int64(startDate.timeIntervalSince1970)
    self.defaultEndDate = Int64(endDate.timeIntervalSince1970)
  }
  
  //MARK: Private Function
  private func getSplitFunction(forSplit splitCategory: DataCategory)
    -> (_ feedbackDetail: Promise<[FeedbackItem]>)
    -> ((startDate: Int64, endDate: Int64))
    -> Promise<[String : [Date : [FeedbackItem]]]> {
      return { (feedbackDetail: Promise<[FeedbackItem]>)
        -> ((startDate: Int64, endDate: Int64))
        -> Promise<[String : [Date : [FeedbackItem]]]> in
        switch splitCategory {
        case .none:
          return self.feedbackDetailsGroupedByDates(feedbackDetails: feedbackDetail)
        case .platform:
          return self.feedbackDetailsGroupedByPlatform(feedbackDetails: feedbackDetail)
        case .browser:
          return self.feedbackDetailsGroupedByBrowser(feedbackDetails: feedbackDetail)
        }
      }
  }
  private func createLineChartData (_ data: [String: [ChartDataEntry]]) -> LineChartData {
      return data.map { data -> LineChartDataSet in
        let chartDataSet = LineChartDataSet(values: data.value, label: data.key)
        chartDataSet.colors = [generateRandomColor()]
        chartDataSet.fillColor = generateRandomColor()
        chartDataSet.highlightEnabled = true
        chartDataSet.highlightColor = UIColor.gray
        chartDataSet.circleColors = [generateRandomColor()]
        chartDataSet.lineWidth = 3
        chartDataSet.drawValuesEnabled = false
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.drawCircleHoleEnabled = false
        chartDataSet.drawIconsEnabled = true
        
        return chartDataSet }
        |> LineChartData.init(dataSets:)
  }
}
