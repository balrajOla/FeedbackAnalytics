//
//  HomeScreenViewController+Charts.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 17/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import UIKit
import Charts

extension HomeScreenViewController {
  func setUpLineChartAverageRatingView() {
    self.lineChartView.setViewPortOffsets(left: 10, top: 20, right: 20, bottom: 10)
    
    self.lineChartView.dragEnabled = true
    self.lineChartView.setScaleEnabled(true)
    self.lineChartView.pinchZoomEnabled = false
    self.lineChartView.maxHighlightDistance = 300
    self.lineChartView.legend.enabled = false
    
    let yAxis = self.lineChartView.leftAxis
    yAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size:12)!
    yAxis.setLabelCount(6, force: false)
    yAxis.labelTextColor = .black
    yAxis.labelPosition = .insideChart
    yAxis.axisLineColor = .black
    
    self.lineChartView.xAxis.valueFormatter = LineChartViewFormatter()
    self.lineChartView.xAxis.granularity = 1.0
  }
  
  func setUpLineChartPerCountView() {
    self.lineChartRatingCountView.setViewPortOffsets(left: 10, top: 20, right: 20, bottom: 10)
    
    self.lineChartRatingCountView.dragEnabled = true
    self.lineChartRatingCountView.setScaleEnabled(true)
    self.lineChartRatingCountView.pinchZoomEnabled = false
    self.lineChartRatingCountView.maxHighlightDistance = 300
    self.lineChartRatingCountView.legend.enabled = false
    
    let yAxis = self.lineChartRatingCountView.leftAxis
    yAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size:12)!
    yAxis.setLabelCount(6, force: false)
    yAxis.labelTextColor = .black
    yAxis.labelPosition = .insideChart
    yAxis.axisLineColor = .black
    
    self.lineChartRatingCountView.xAxis.valueFormatter = LineChartViewFormatter()
    self.lineChartRatingCountView.xAxis.granularity = 1.0
  }
  
  func setLineChartDataForRatingAveragePerDay() {
    Loader.show()
    viewModel.getFeedbackDetailsInfoPerDay(withLabel: "Emotional trendline",with: { value -> Double in (value.map { $0.rating }).average })
      .done(on: DispatchQueue.main) { (result) in
        self.lineChartView.data = result
        self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
      }.catch { _ in
        self.lineChartView.data = nil
      }
      .finally {
        Loader.hide()
    }
  }
  
  func setLineChartDataForRatingCountPerDay() {
    Loader.show()
    viewModel.getFeedbackDetailsInfoPerDay(withLabel: "Feedback items", with: { value -> Double in Double(value.count) })
      .done(on: DispatchQueue.main) { (result) in
        self.lineChartRatingCountView.data = result
        self.lineChartRatingCountView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
      }.catch { _ in
        self.lineChartRatingCountView.data = nil
      }
      .finally {
        Loader.hide()
    }
  }
  
  func setAverageRating() {
    viewModel.getAverageRatingForSelectedRange()
      .done {
        self.averageRatingLabel.text = "Average Rating: \($0)"
      }.catch { _ in
        self.averageRatingLabel.text = "Average Rating: NA"
    }
  }
}
