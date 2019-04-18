//
//  ReaderMonad.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 14/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation

public struct Reader<E, A> {
  
  let f: (E) -> A
  static func unit<E, A>(_ a: A) -> Reader<E, A> {
    return Reader<E, A>{_ in a}
  }
  
  func run(_ e: E) -> A {
    return f(e)
  }
  
  func map<B>(_ g: @escaping (A) -> B) -> Reader<E, B> {
    return Reader<E, B> { e in g(self.run(e)) }
  }
  
  func flatMap<B>(_ g: @escaping (A) -> Reader<E, B>) -> Reader<E, B> {
    return Reader<E, B> { e in g(self.run(e)).run(e) }
  }
}

precedencegroup LeftApplyPrecedence {
  associativity: left
  higherThan: AssignmentPrecedence
  lowerThan: TernaryPrecedence
}

infix operator >>= : LeftApplyPrecedence
infix operator >>>= : LeftApplyPrecedence
infix operator >>=> : LeftApplyPrecedence

func >>= <E, A, B>(a: Reader<E, A>, f: @escaping (A) -> Reader<E, B>) -> Reader<E, B> {
  return a.flatMap(f)
}

func >>>= <E, A, B>(a: Reader<E, A>, f: @escaping (A) -> B) -> Reader<E, B> {
  return a.map(f)
}

func >>=> <E, A, B, C>(a: Reader<E, [A: B]>, f: @escaping (B) -> [C: B]) -> Reader<E, [A: [C: B]]> {
  return a.map { $0.mapValues(f) }
}


