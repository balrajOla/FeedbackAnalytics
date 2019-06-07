//
//  HttClient.swift
//  FeedbackAnalytics
//
//  Created by Balraj Singh on 07/06/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

protocol HttpClientProtocol {
    func request(route: Route) -> Promise<Data>
}

struct HttClient: HttpClientProtocol {
    public let serverConfig: ServerConfigType
    
    public init(serverConfig: ServerConfigType = ServerConfig.production) {
        self.serverConfig = serverConfig
    }
    
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
}
