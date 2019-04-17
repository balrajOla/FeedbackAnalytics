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
import DropDown

class HomeScreenViewController: UIViewController {
  @IBOutlet weak var calendarRangeSelectorBtn: UIButton!
  
  @IBOutlet weak var btnSelectedCategory: UIButton!
  @IBOutlet weak var averageRatingLabel: UILabel!
  @IBOutlet weak var lineChartRatingCountView: LineChartView!
  @IBOutlet weak var splitByDropDown: UIView!
  @IBOutlet weak var lineChartView: LineChartView!
  let dropDown = DropDown()
  
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
    self.setUpSplitByDropdown()
  }

  @IBAction func didCalendarTapped(_ sender: Any) {
    self.presentCalendarView()
  }
  
  @IBAction func showSplitCategoryBtnClick(_ sender: Any) {
    self.dropDown.show()
  }
  
  func setUpSplitByDropdown() {
    // The view to which the drop down will appear on
    dropDown.anchorView = self.splitByDropDown // UIView
    
    // The list of items to display. Can be changed dynamically
    dropDown.dataSource = self.viewModel.splitByList
    
    // Action triggered on selection
    dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
      
    }
  }
}
