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
  
  @IBOutlet weak var averageRatingLabel: UILabel!
  @IBOutlet weak var lineChartRatingCountView: LineChartView!
  
  @IBOutlet weak var lineChartView: LineChartView!
  public let viewModel = HomeScreenViewModel()
  
  var dateRangePickerViewController: CalendarDateRangePickerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feedback Analytics"
        self.setSettingsForCalendarView()
        self.setUpLineChartAverageRatingView()
        self.setUpLineChartPerCountView()
      
        self.setLineChartDataForRatingAveragePerDay()
        self.setLineChartDataForRatingCountPerDay()
        self.updateCalendarSelectionBtnLabel()
        self.setAverageRating()
       // Do any additional setup after loading the view.
    }

  @IBAction func didCalendarTapped(_ sender: Any) {
    self.presentCalendarView()
  }
}
