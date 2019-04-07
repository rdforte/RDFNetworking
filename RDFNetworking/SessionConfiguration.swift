//
//  SessionConfiguration.swift
//  RDFNetworking
//
//  Created by ryan del forte on 5/4/19.
//  Copyright © 2019 ryan del forte. All rights reserved.
//

import Foundation

public protocol URLSessionDataTaskProtocol {
    func resume()
}

public protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let task = dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
        return task as URLSessionDataTaskProtocol
    }
}

// don't need .resume() as already handled by URLSessionDataTask
extension URLSessionDataTask: URLSessionDataTaskProtocol {}
