//
//  XCTestCase+MemoryLeakTracking.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 08/06/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
