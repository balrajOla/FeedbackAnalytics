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
    
    self.dateRangePickerViewController?.minimumDate = AppEnvironment.current.calendar.date(byAdding: .year, value: -10, to: todayDate)
      self.dateRangePickerViewController?.maximumDate = todayDate
  }
  
  func presentCalendarView() {
    self.dateRangePickerViewController.map {
      let navigationController = UINavigationController(rootViewController: $0)
      self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
  }
  
  // MARK: CalendarDateRangePickerViewControllerDelegate
  func didTapCancel() {
    self.dateRangePickerViewController?.dismiss(animated: true, completion: nil)
  }
  
  func didTapDoneWithDateRange(startDate: Date!, endDate: Date!) {
    self.dateRangePickerViewController?.dismiss(animated: true, completion: nil)
  }
}
