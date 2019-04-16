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

public class HomeScreenViewModel {
  
  private let feedbackUsecase = FeedbackDetailsUsecase()
  
  private let defaultStartDate: Int64 = 1381365800
  private let defaultEndDate: Int64 = 1491446293
  private let defaultValue = 0
  
  
  public func getFeedbackDetailsWithAverageRating() -> Promise<PieChartData> {
    let feebackDetailsGroupByRating = self.feedbackUsecase.getFeedbackDetails()
                             |> self.feedbackDetailsGroupedByRating(feedbackDetails:)
    
    return ((startDate: defaultStartDate, endDate: defaultEndDate)
           |> feebackDetailsGroupByRating)
            .map(on: DispatchQueue.global(qos: .utility)) { (response) -> PieChartData in
        
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
  
  public func getFeedbackDetailsWithAverageRatingPerDay() -> Promise<LineChartData> {
    let feebackDetailsGroupByDate = self.feedbackUsecase.getFeedbackDetails()
      |> self.feedbackDetailsGroupedByDates(feedbackDetails:)
    
    return ((startDate: defaultStartDate, endDate: defaultEndDate)
      |> feebackDetailsGroupByDate)
      .map(on: DispatchQueue.global(qos: .utility)) { response -> LineChartData in
        
        return response.map { item -> (Date, Double) in
          return (item.key, (item.value.map { $0.rating }).average)
          }.reduce(([ChartDataEntry](), [UIColor]())) { (res, item) -> ([ChartDataEntry], [UIColor]) in
            var result = res
            print("Date: \(item.0.timeIntervalSince1970), value: \(item.1)")
            result.0.append(ChartDataEntry(x: item.0.timeIntervalSince1970, y: item.1))
            result.1.append(UIColor(red: CGFloat(Double(arc4random_uniform(256))/255), green: CGFloat(Double(arc4random_uniform(256))/255), blue: CGFloat(Double(arc4random_uniform(256))/255), alpha: 1))
            
            return result
          }
          |> self.createLineChartData(from:)
    }
  }
  
  
  //MARK: Private Function
  private func createLineChartData(from data: ([ChartDataEntry], [UIColor])) -> LineChartData {
    let chartDataSet = LineChartDataSet(values: data.0, label: "Average Rating Per Day")
    chartDataSet.colors = data.1
    
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
