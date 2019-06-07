//
//  HomeScreenViewModel.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 15/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import Charts
import PromiseKit

public enum FeedbackDetailsDataError: Error {
    case noData
}

public enum DataCategory: String {
    case none = "None"
    case platform = "Platform"
    case browser = "Browser"
}

public class HomeScreenViewModel {
    
    // Dependencies
    private let feedbackUsecase: FeedbackDetailsUsecaseProtocol
    private let dataProcessingUsecase: FeedbackDetailsDataProcessingUsecaseProtocol
    
    // Start and end date
    private var defaultStartDate: Int64 = 1388534400
    private var defaultEndDate: Int64 = 1391745497
    
    // categories by which data can be splitted by
    public let splitByList = [DataCategory.none.rawValue, DataCategory.platform.rawValue, DataCategory.browser.rawValue]
    
    init(dataProcessingUsecase: FeedbackDetailsDataProcessingUsecaseProtocol,
         feedbackUsecase: FeedbackDetailsUsecaseProtocol) {
        self.dataProcessingUsecase = dataProcessingUsecase
        self.feedbackUsecase = feedbackUsecase
    }
    
    // func to get feedback details for a selected category and dates
    public func getFeedbackDetailsRatingPerDay(withLabel label: String,
                                               withSplitBy splitBy: DataCategory,
                                               with query: @escaping ([FeedbackItem]) -> Double) -> Promise<LineChartData> {
        let splitByFn = self.getSplitFunction(forSplit: splitBy)
        let feebackDetailsGroupByDate = self.feedbackUsecase.getFeedbackDetails() |> splitByFn
        let mapAndSortWithQuery = self.mapAndSort(with: query)
        
        return ((startDate: defaultStartDate, endDate: defaultEndDate) |> feebackDetailsGroupByDate)
            .map(on: DispatchQueue.global(qos: .utility)) {[weak self] response -> LineChartData in
                guard !response.isEmpty,
                    let self = self else {
                        throw FeedbackDetailsDataError.noData
                }
                
                return response
                    |> mapAndSortWithQuery
                    |> self.reduceData(toChartDataEntry:)
                    |> self.createLineChartData
        }
    }
    
    public func getAverageRatingForSelectedRange() -> Promise<Double> {
        return
            ((startDate: defaultStartDate, endDate: defaultEndDate)
                |> (self.feedbackUsecase.getFeedbackDetails()
                    |> self.dataProcessingUsecase.feedbackDetailsFilterByDates(feedbackDetails:)))
                |> self.calculateRatingAverage(forFeedbackDetails:)
    }
    
    public func getBetweenDates() -> (startDate: Date, endDate: Date) {
        return (startDate: Date(timeIntervalSince1970: TimeInterval(self.defaultStartDate)), endDate: Date(timeIntervalSince1970: TimeInterval(self.defaultEndDate)))
    }
    
    public func setBetweenDate(startDate: Date, endDate: Date) {
        self.defaultStartDate = Int64(startDate.timeIntervalSince1970)
        self.defaultEndDate = Int64(endDate.timeIntervalSince1970)
    }
    
    //MARK: Private Function
    private func calculateRatingAverage(forFeedbackDetails data: Promise<[FeedbackItem]>) -> Promise<Double> {
        return data.map {
            guard !$0.isEmpty else {
                throw FeedbackDetailsDataError.noData
            }
            
            return ($0.map{ $0.rating }).average
        }
    }
    
    private func mapAndSort(with query: @escaping ([FeedbackItem]) -> Double)
        -> (_ data: [String : [Date : [FeedbackItem]]])
        -> [String : [(Date, Double)]] {
            return { (_ data: [String : [Date : [FeedbackItem]]])
                -> [String : [(Date, Double)]] in
                return data.mapValues {
                    return $0.map { item -> (Date, Double) in
                        return (item.key, query(item.value))
                        }.sorted(by: { (valueOne, valueSecond) -> Bool in
                            return valueOne.0 < valueSecond.0
                        })
                }
            }
    }
    
    private func reduceData(toChartDataEntry data: [String : [(Date, Double)]]) -> [String: [ChartDataEntry]] {
        return data
            .reduce([String: [ChartDataEntry]]()) { (res, item) -> [String: [ChartDataEntry]] in
                var result = res
                result[item.key] = item.value.reduce([ChartDataEntry]()) { (res, item) -> [ChartDataEntry] in
                    var result = res
                    result.append(ChartDataEntry(x: item.0.timeIntervalSince1970, y: item.1))
                    
                    return result
                }
                return result
        }
    }
    
    private func getSplitFunction(forSplit splitCategory: DataCategory)
        -> (_ feedbackDetail: Promise<[FeedbackItem]>)
        -> ((startDate: Int64, endDate: Int64))
        -> Promise<[String : [Date : [FeedbackItem]]]> {
            return {[weak self] (feedbackDetail: Promise<[FeedbackItem]>)
                -> ((startDate: Int64, endDate: Int64))
                -> Promise<[String : [Date : [FeedbackItem]]]> in
                guard let self = self else {
                    return { (_ between: (startDate: Int64, endDate: Int64))
                        -> Promise<[String: [Date : [FeedbackItem]]]> in
                        return Promise<[String : [Date : [FeedbackItem]]]>(error: FeedbackDetailsDataError.noData)
                    }
                }
                
                switch splitCategory {
                case .none:
                    return self.dataProcessingUsecase.feedbackDetailsGroupedByDates(feedbackDetails: feedbackDetail)
                case .platform:
                    return self.dataProcessingUsecase.feedbackDetailsGroupedByPlatform(feedbackDetails: feedbackDetail)
                case .browser:
                    return self.dataProcessingUsecase.feedbackDetailsGroupedByBrowser(feedbackDetails: feedbackDetail)
                }
            }
    }
    private func createLineChartData (_ data: [String: [ChartDataEntry]]) -> LineChartData {
        return data.map { data -> LineChartDataSet in
            let chartDataSet = LineChartDataSet(entries: data.value, label: data.key)
            chartDataSet.colors = [generateRandomColor()]
            chartDataSet.fillColor = generateRandomColor()
            chartDataSet.highlightEnabled = true
            chartDataSet.highlightColor = UIColor.gray
            chartDataSet.circleColors = [generateRandomColor()]
            chartDataSet.lineWidth = 3
            chartDataSet.drawValuesEnabled = false
            chartDataSet.drawCirclesEnabled = false
            chartDataSet.drawCircleHoleEnabled = false
            chartDataSet.drawIconsEnabled = true
            
            return chartDataSet }
            |> LineChartData.init(dataSets:)
    }
}
