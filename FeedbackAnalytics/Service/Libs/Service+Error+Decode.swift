//
//  Service+Error+Decode.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 06/06/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

enum ServiceError: Error {
  case urlInvalid
  case parsingIssue
  case noInternet
  case selfDeinit
}

extension Service {
  public func decode<T: Decodable>(response: Promise<Data>) -> Promise<T> {
    return response.compactMap(on: DispatchQueue.global(qos: .utility)) { try JSONDecoder().decode(T.self, from: $0) }
  }
}
