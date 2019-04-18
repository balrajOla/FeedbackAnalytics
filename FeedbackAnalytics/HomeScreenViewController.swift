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
    self.setUpRightNavigationBarButton()
  }
  
  @IBAction func didCalendarTapped(_ sender: Any) {
    self.presentCalendarView()
  }
  
  @IBAction func showSplitCategoryBtnClick(_ sender: Any) {
    self.dropDown.show()
  }
  
  func setUpRightNavigationBarButton() {
    let saveReport = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveReportBtnTap))
    self.navigationItem.rightBarButtonItem = saveReport
  }
  
  @objc func saveReportBtnTap() {
    self.lineChartRatingCountView.getChartImage(transparent: false).map {
      UIImageWriteToSavedPhotosAlbum($0, nil, nil, nil)
    }
    
    self.lineChartView.getChartImage(transparent: false).map {
      UIImageWriteToSavedPhotosAlbum($0, nil, nil, nil)
    }
    
    self.showToast(message: "Graphs image has been saved to gallery...")
  }
  
  func setUpSplitByDropdown() {
    // The view to which the drop down will appear on
    dropDown.anchorView = self.splitByDropDown // UIView
    
    // The list of items to display. Can be changed dynamically
    dropDown.dataSource = self.viewModel.splitByList
    
    // Action triggered on selection
    dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
      let splitByCategory = DataCategory(rawValue: item) ?? DataCategory.none
      self.updateSplitByBtnText(withSplitBy: splitByCategory)
      self.setLineChartDataForRatingAveragePerDay(withSplit: splitByCategory)
      self.setLineChartDataForRatingCountPerDay(withSplit: splitByCategory)
    }
  }
  
  func updateSplitByBtnText(withSplitBy splitBy: DataCategory = DataCategory.none) {
    self.btnSelectedCategory.setTitle("Split By: \(splitBy.rawValue)", for: .normal)
  }
}
