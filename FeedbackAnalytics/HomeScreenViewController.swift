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
  
  @IBOutlet weak var lineChartRatingCountView: LineChartView!
  
  @IBOutlet weak var lineChartView: LineChartView!
  public let viewModel = HomeScreenViewModel()
  
  var dateRangePickerViewController: CalendarDateRangePickerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feedback Analytics"
        self.setSettingsForCalendarView()
      
        self.setLineChartDataForRatingAveragePerDay()
        self.setLineChartDataForRatingCountPerDay()
        self.updateCalendarSelectionBtnLabel()
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
  
  func setLineChartDataForRatingAveragePerDay() {
    Loader.show()
    viewModel.getFeedbackDetailsRatingPerDay(with: { value -> Double in (value.map { $0.rating }).average })
      .done(on: DispatchQueue.main) { (result) in
        self.lineChartView.data = result
        self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
      }.catch { _ in}
      .finally {
        Loader.hide()
    }
  }
  
  func setLineChartDataForRatingCountPerDay() {
    Loader.show()
    viewModel.getFeedbackDetailsRatingPerDay(with: { value -> Double in Double(value.count) })
      .done(on: DispatchQueue.main) { (result) in
        self.lineChartRatingCountView.data = result
        self.lineChartRatingCountView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
      }.catch { _ in}
      .finally {
        Loader.hide()
    }
  }
}
