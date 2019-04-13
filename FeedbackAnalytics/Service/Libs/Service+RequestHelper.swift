//
//  Service+RequestHelper.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

enum ServiceError: Error {
  case urlInvalid
  case parsingIssue
  case noInternet
}

extension Service {
  func request(route: Route) -> Promise<Data> {
    let url = serverConfig.apiBaseUrl.appendingPathComponent(route.requestProperties.path)
      
    return Promise<Data> { seal in
      Alamofire.request(url,
                        method: route.requestProperties.method,
                        parameters: route.requestProperties.query,
                        encoding: URLEncoding.default,
                        headers: nil)
        .validate(statusCode: 200..<300)
        .responseData(completionHandler: { response in
          switch response.result {
          case .success(let value):
            seal.fulfill(value)
          case .failure(let error):
            seal.reject(error)
          }
        })
    }
  }
  
  public func decode<T: Decodable>(response: Promise<Data>) -> Promise<T> {
    return response.compactMap(on: DispatchQueue.global(qos: .utility)) { try JSONDecoder().decode(T.self, from: $0) }
  }
}
