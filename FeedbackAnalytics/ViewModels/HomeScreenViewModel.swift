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
  private let defaultValue: Float = 0
  
  public func getFeedbackDetailsWithAverageRating() -> Promise<PieChartData> {
    return self.feedbackUsecase.getFeedbackDetailsGroupedByRating(between: (startDate: defaultStartDate, endDate: defaultEndDate))
      .map(on: DispatchQueue.global(qos: .utility)) { (response) -> PieChartData in
        
        return response.map { (item) -> (Int, Float) in
          return (item.key, (item.value.reduce(self.defaultValue) { (result: Float, item) -> Float in return (result + Float(item.rating)) } / Float(item.value.count)))
          }.reduce(([PieChartDataEntry](), [UIColor]())) { (res, item) -> ([PieChartDataEntry], [UIColor]) in
            print("rating: \(item.0) average: \(item.1)")
            var result = res
            result.0.append(PieChartDataEntry(value: Double(item.1), label: "Rating \(item.1)"))
            result.1.append(UIColor(red: CGFloat(Double(arc4random_uniform(256))/255), green: CGFloat(Double(arc4random_uniform(256))/255), blue: CGFloat(Double(arc4random_uniform(256))/255), alpha: 1))
            
            return result
          }
          |> self.createPieChartData(from:)
        
    }
  }
  
  private func createPieChartData(from data: ([PieChartDataEntry], [UIColor])) -> PieChartData {
    let pieChartDataSet = PieChartDataSet(values: data.0, label: "Rating's Average")
    pieChartDataSet.colors = data.1
    return PieChartData(dataSet: pieChartDataSet)
  }
}
