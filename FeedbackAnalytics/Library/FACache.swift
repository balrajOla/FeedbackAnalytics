//
//  FACache.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation

public final class FACache {
  private let cache = NSCache<NSString, AnyObject>()
  
  public init() {
  }
  
  public subscript(key: String) -> Any? {
    get {
      return self.cache.object(forKey: key as NSString)
    }
    set {
      if let newValue = newValue {
        self.cache.setObject(newValue as AnyObject, forKey: key as NSString)
      } else {
        self.cache.removeObject(forKey: key as NSString)
      }
    }
  }
  
  public func removeAllObjects() {
    self.cache.removeAllObjects()
  }
}
