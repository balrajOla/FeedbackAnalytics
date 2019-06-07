//
//  ServiceType.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 06/06/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit

public protocol ServiceType {
    func fetchFeedbackDetails() -> Promise<FeedbackDetailsResponse>
}
