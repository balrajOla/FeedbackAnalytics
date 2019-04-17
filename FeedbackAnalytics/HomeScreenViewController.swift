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
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
  func setUpLineChartAverageRatingView() {
    self.lineChartView.setViewPortOffsets(left: 0, top: 20, right: 0, bottom: 0)
    
    self.lineChartView.dragEnabled = true
    self.lineChartView.setScaleEnabled(true)
    self.lineChartView.pinchZoomEnabled = false
    self.lineChartView.maxHighlightDistance = 300
    
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
    self.lineChartRatingCountView.setViewPortOffsets(left: 0, top: 20, right: 0, bottom: 0)
    
    self.lineChartRatingCountView.dragEnabled = true
    self.lineChartRatingCountView.setScaleEnabled(true)
    self.lineChartRatingCountView.pinchZoomEnabled = false
    self.lineChartRatingCountView.maxHighlightDistance = 300
    
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
    viewModel.getFeedbackDetailsRatingPerDay(withLabel: "Emotional trendline",with: { value -> Double in (value.map { $0.rating }).average })
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
    viewModel.getFeedbackDetailsRatingPerDay(withLabel: "Feedback items", with: { value -> Double in Double(value.count) })
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
