//
//  HomeScreenViewController.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 15/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import CalendarDateRangePickerViewController

extension HomeScreenViewController: CalendarDateRangePickerViewControllerDelegate {
  func setSettingsForCalendarView() {
    self.dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
    self.dateRangePickerViewController?.delegate = self
    let todayDate = AppEnvironment.current.dateType.init().date
    
    self.dateRangePickerViewController?.minimumDate = AppEnvironment.current.calendar.date(byAdding: .month, value: -76, to: todayDate)
      self.dateRangePickerViewController?.maximumDate = todayDate
  }
  
  func presentCalendarView() {
    self.dateRangePickerViewController.map {
      $0.selectedStartDate = viewModel.getBetweenDates().startDate
      $0.selectedEndDate = viewModel.getBetweenDates().endDate
      
      let navigationController = UINavigationController(rootViewController: $0)
      self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
  }
  
  // MARK: CalendarDateRangePickerViewControllerDelegate
  func didTapCancel() {
    self.dateRangePickerViewController?.dismiss(animated: true, completion: nil)
  }
  
  func didTapDoneWithDateRange(startDate: Date!, endDate: Date!) {
    self.viewModel.setBetweenDate(startDate: startDate, endDate: endDate)
    self.updateCalendarSelectionBtnLabel()
    self.setLineChartDataForRatingAveragePerDay()
    self.setLineChartDataForRatingCountPerDay()
    self.setAverageRating()
    self.dateRangePickerViewController?.dismiss(animated: true, completion: nil)
  }
  
  func updateCalendarSelectionBtnLabel() {
    let selectedDates = self.viewModel.getBetweenDates()
    self.calendarRangeSelectorBtn.setTitle("Showing data from \(self.formatDate(date: selectedDates.startDate)) to \(self.formatDate(date: selectedDates.endDate))", for: .normal)
  }
  
  private func formatDate(date: Date) -> String {
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "MMM dd,yyyy"
    return dateFormatterPrint.string(from: date)
  }
}
