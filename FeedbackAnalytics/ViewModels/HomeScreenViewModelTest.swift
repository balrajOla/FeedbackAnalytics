//
//  HomeScreenViewModelTest.swift
//  FeedbackAnalyticsUnitTests
//
//  Created by Balraj Singh on 08/06/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import XCTest
@testable import FeedbackAnalytics

class HomeScreenViewModelTest: XCTestCase {

    func test_HomeScreenViewModel_MemoryLeak() {
        let viewModel = HomeScreenViewModel(dataProcessingUsecase: FeedbackDetailsDataProcessingUsecase(),
                                            feedbackUsecase: FeedbackDetailsUsecase())
        
        _ = viewModel.getFeedbackDetailsRatingPerDay(withLabel: "Sample", withSplitBy: .none) { (data) -> Double in
            return 0
        }
        
        self.trackForMemoryLeaks(viewModel)
    }
}
