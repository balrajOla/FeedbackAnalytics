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

public class HomeScreenViewModel {
  
  private let feedbackUsecase = FeedbackDetailsUsecase()
  
  private var defaultStartDate: Int64 = 1381365800
  private var defaultEndDate: Int64 = 1491446293
  private let defaultValue = 0
  
  public func getFeedbackDetailsRatingPerDay(withLabel label: String,
                                             with query: @escaping ([FeedbackItem]) -> Double) -> Promise<LineChartData> {
    let feebackDetailsGroupByDate = self.feedbackUsecase.getFeedbackDetails()
      |> self.feedbackDetailsGroupedByDates(feedbackDetails:)
    let createLineChartDataWithLabel = self.createLineChartData(withLabel: label)
    
    return ((startDate: defaultStartDate, endDate: defaultEndDate)
      |> feebackDetailsGroupByDate)
      .map(on: DispatchQueue.global(qos: .utility)) { response -> LineChartData in
        guard response.count > 0 else {
          throw FeedbackDetailsDataError.noData
        }
        
        return response.map { item -> (Date, Double) in
          return (item.key, query(item.value))
          }.sorted(by: { (valueOne, valueSecond) -> Bool in
            return valueOne.0 < valueSecond.0
          })
          .reduce([ChartDataEntry]()) { (res, item) -> [ChartDataEntry] in
            var result = res
            print("Date: \(item.0.timeIntervalSince1970), value: \(item.1)")
            result.append(ChartDataEntry(x: item.0.timeIntervalSince1970, y: item.1))
            
            return result
          }
          |> createLineChartDataWithLabel
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
  private func createLineChartData(withLabel label: String)
    -> (_ data: [ChartDataEntry])
    -> LineChartData {
      return { (data: [ChartDataEntry])
        -> LineChartData in
        let color = UIColor(red: CGFloat(Double(arc4random_uniform(256))/255), green: CGFloat(Double(arc4random_uniform(256))/255), blue: CGFloat(Double(arc4random_uniform(256))/255), alpha: 1)
        
        let chartDataSet = LineChartDataSet(values: data, label: label)
        chartDataSet.colors = [color]
        
        let chartData = LineChartData(dataSet: chartDataSet)
        return chartData
      }
  }
  
  private func createBarChartData(from data: ([BarChartDataEntry], [UIColor])) -> BarChartData {
    let barWidth = 1.0
    
    let barChartDataSet = BarChartDataSet(values: data.0, label: "Per Platform Rating Count")
    barChartDataSet.colors = data.1
    
    let barChartData = BarChartData(dataSet: barChartDataSet)
    barChartData.barWidth = barWidth
    barChartData.setValueFont(UIFont(name:"HelveticaNeue-Light", size:10)!)
    return barChartData
  }
  
  private func createPieChartData(from data: ([PieChartDataEntry], [UIColor])) -> PieChartData {
    let pieChartDataSet = PieChartDataSet(values: data.0, label: "Per Rating Count")
    pieChartDataSet.colors = data.1
    return PieChartData(dataSet: pieChartDataSet)
  }
}
