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
  
  public func getFeedbackDetailsWithAverageRating() -> Promise<PieChartData> {
    let feebackDetailsGroupByRating = self.feedbackUsecase.getFeedbackDetails()
      |> self.feedbackDetailsGroupedByRating(feedbackDetails:)
    
    return ((startDate: defaultStartDate, endDate: defaultEndDate)
      |> feebackDetailsGroupByRating)
      .map(on: DispatchQueue.global(qos: .utility)) { (response) -> PieChartData in
        guard response.count > 0 else {
          throw FeedbackDetailsDataError.noData
        }
        
        return response.map { (item) -> (Int, Int) in
          return (item.key, (item.value.count))
          }.reduce(([PieChartDataEntry](), [UIColor]())) { (res, item) -> ([PieChartDataEntry], [UIColor]) in
            var result = res
            result.0.append(PieChartDataEntry(value: Double(item.1), label: "Rating \(item.0)"))
            result.1.append(UIColor(red: CGFloat(Double(arc4random_uniform(256))/255), green: CGFloat(Double(arc4random_uniform(256))/255), blue: CGFloat(Double(arc4random_uniform(256))/255), alpha: 1))
            
            return result
          }
          |> self.createPieChartData(from:)
        
    }
  }
  
  public func getFeedbackDetailsWithRatingCountForPlatform() -> Promise<BarChartData> {
    let feebackDetailsGroupByPlatform = self.feedbackUsecase.getFeedbackDetails()
      |> self.feedbackDetailsGroupedByPlatform(feedbackDetails:)
    
    return ((startDate: defaultStartDate, endDate: defaultEndDate)
      |> feebackDetailsGroupByPlatform)
      .map(on: DispatchQueue.global(qos: .utility)) { response -> BarChartData in
        guard response.count > 0 else {
          throw FeedbackDetailsDataError.noData
        }
        
        let spaceForBar = 5.0
        let randomLimit: UInt32 = 10
        
        return response.map { item -> (String, Int) in
          return (item.key, item.value.count)
          }.reduce(([BarChartDataEntry](), [UIColor]())) { (res, item) -> ([BarChartDataEntry], [UIColor]) in
            var result = res
            let valY = Double(arc4random_uniform(randomLimit))
            result.0.append(BarChartDataEntry(x: Double(item.1) * spaceForBar, y: valY))
            result.1.append(UIColor(red: CGFloat(Double(arc4random_uniform(256))/255), green: CGFloat(Double(arc4random_uniform(256))/255), blue: CGFloat(Double(arc4random_uniform(256))/255), alpha: 1))
            
            return result
          }
          |> self.createBarChartData(from:)
    }
  }
  
  public func getFeedbackDetailsRatingPerDay(with query: @escaping ([FeedbackItem]) -> Double) -> Promise<LineChartData> {
    let feebackDetailsGroupByDate = self.feedbackUsecase.getFeedbackDetails()
      |> self.feedbackDetailsGroupedByDates(feedbackDetails:)
    
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
          |> self.createLineChartData(from:)
    }
  }
  
  public func getBetweenDates() -> (startDate: Date, endDate: Date) {
    return (startDate: Date(timeIntervalSince1970: TimeInterval(self.defaultStartDate)), endDate: Date(timeIntervalSince1970: TimeInterval(self.defaultEndDate)))
  }
  
  public func setBetweenDate(startDate: Date, endDate: Date) {
    self.defaultStartDate = Int64(startDate.timeIntervalSince1970)
    self.defaultEndDate = Int64(endDate.timeIntervalSince1970)
  }
  
  //MARK: Private Function
  private func createLineChartData(from data: [ChartDataEntry]) -> LineChartData {
     let color = UIColor(red: CGFloat(Double(arc4random_uniform(256))/255), green: CGFloat(Double(arc4random_uniform(256))/255), blue: CGFloat(Double(arc4random_uniform(256))/255), alpha: 1)
    
    let chartDataSet = LineChartDataSet(values: data, label: "Average Rating Per Day")
    chartDataSet.colors = [color]
    
    let chartData = LineChartData(dataSet: chartDataSet)
    return chartData
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
