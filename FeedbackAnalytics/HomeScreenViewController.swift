//
//  HomeScreenViewController.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import UIKit
import CalendarDateRangePickerViewController
import Charts

class HomeScreenViewController: UIViewController {
  @IBOutlet weak var calendarRangeSelectorBtn: UIButton!
  
  @IBOutlet weak var ratingAveragePieChart: PieChartView!
  
  @IBOutlet weak var platformsRatingsCountBarChart: HorizontalBarChartView!
  
  private let viewModel = HomeScreenViewModel()
  
  var dateRangePickerViewController: CalendarDateRangePickerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feedback Analytics"
        self.setSettingsForCalendarView()
        self.setPlatformRatingCountSettings()
      
        self.setRatingAveragePieChartData()
        self.setPlatformRatingCountData()
        // Do any additional setup after loading the view.
    }

  @IBAction func didCalendarTapped(_ sender: Any) {
    self.presentCalendarView()
  }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

  private func setRatingAveragePieChartData() {
    Loader.show()
    viewModel.getFeedbackDetailsWithAverageRating()
      .done(on: DispatchQueue.main) { (result) in
        self.ratingAveragePieChart.data = result
        self.ratingAveragePieChart.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
      }.catch { _ in}
      .finally {
        Loader.hide()
    }
  }
  
  private func setPlatformRatingCountSettings() {
    let xAxis = self.platformsRatingsCountBarChart.xAxis
    xAxis.labelPosition = .bottom
    xAxis.labelFont = .systemFont(ofSize: 10)
    xAxis.drawAxisLineEnabled = true
    xAxis.granularity = 10
    
    let leftAxis = self.platformsRatingsCountBarChart.leftAxis
    leftAxis.labelFont = .systemFont(ofSize: 10)
    leftAxis.drawAxisLineEnabled = true
    leftAxis.drawGridLinesEnabled = true
    leftAxis.axisMinimum = 0
    
    let rightAxis = self.platformsRatingsCountBarChart.rightAxis
    rightAxis.enabled = true
    rightAxis.labelFont = .systemFont(ofSize: 10)
    rightAxis.drawAxisLineEnabled = true
    rightAxis.axisMinimum = 0
  }
  
  private func setPlatformRatingCountData() {
    Loader.show()
    viewModel.getFeedbackDetailsWithRatingCountForPlatform()
      .done(on: DispatchQueue.main) { (result) in
        self.platformsRatingsCountBarChart.data = result
        self.platformsRatingsCountBarChart.animate(yAxisDuration: TimeInterval(1))
      }.catch { _ in}
      .finally {
        Loader.hide()
    }
  }
}
