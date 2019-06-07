//
//  Sequence+Reader.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 14/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation

public extension Sequence {
  
    func groupBy<T: Hashable>(_ keyPath: KeyPath<Element, T>) -> [T: [Iterator.Element]] {
    var results = [T: Array<Iterator.Element>]()
    
    forEach {
      let key = $0[keyPath: keyPath]
      
      if var array = results[key] {
        array.append($0)
        results[key] = array
      }
      else {
        results[key] = [$0]
      }
    }
    
    return results
  }
}

public func sort<T>(by sortFn: @escaping (T, T) -> Bool) -> Reader<[T], [T]> {
  return Reader { value in
    return value.sorted(by: sortFn)
  }
}

public func filter<T>(isIncluded predicate: @escaping (T) -> Bool) -> Reader<[T], [T]> {
  return Reader { value in
    return value.filter(predicate)
  }
}

public func groupBy<T, R: Hashable>(_ keyPath: KeyPath<T, R>) -> Reader<[T], [R: [T]]> {
  return Reader { value in
    return value.groupBy(keyPath)
  }
}
