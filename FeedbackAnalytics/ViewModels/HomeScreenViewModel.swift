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
    return self.feedbackUsecase.getFeedbackDetailsGroupedByRating(between: (startDate: defaultStartDate, endDate: defaultEndDate))
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
    return self.feedbackUsecase.getFeedbackDetailsGroupedByPlatform(between: (startDate: defaultStartDate, endDate: defaultEndDate))
      .map(on: DispatchQueue.global(qos: .utility)) { response -> BarChartData in
        let spaceForBar = 2
        let randomLimit: UInt32 = 10
        
        return response.map { item -> (String, Int) in
          return (item.key, item.value.count)
          }.reduce(([BarChartDataEntry](), [UIColor]())) { (res, item) -> ([BarChartDataEntry], [UIColor]) in
            var result = res
            let valY = Double(arc4random_uniform(randomLimit))
            result.0.append(BarChartDataEntry(x: Double(item.1 * spaceForBar), y: valY))
            result.1.append(UIColor(red: CGFloat(Double(arc4random_uniform(256))/255), green: CGFloat(Double(arc4random_uniform(256))/255), blue: CGFloat(Double(arc4random_uniform(256))/255), alpha: 1))
            
            return result
        }
        |> self.createBarChartData(from:)
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
