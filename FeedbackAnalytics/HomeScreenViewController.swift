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
        self.setRatingAveragePieChartData()
        self.setPlatformRatingCount()
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
      }.catch { _ in}
      .finally {
        Loader.hide()
    }
  }
  
  private func setPlatformRatingCount() {
    Loader.show()
    viewModel.getFeedbackDetailsWithRatingCountForPlatform()
      .done(on: DispatchQueue.main) { (result) in
        self.platformsRatingsCountBarChart.data = result
      }.catch { _ in}
      .finally {
        Loader.hide()
    }
  }
}
