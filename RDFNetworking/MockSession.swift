//
//  MockSession.swift
//  RDFNetworking
//
//  Created by ryan del forte on 5/4/19.
//  Copyright © 2019 ryan del forte. All rights reserved.
//

import UIKit

internal enum MockError: String {
    case mockURLFailed = "failed url Conversion"
}

extension MockError: LocalizedError {
    public var errorDescription: String? {
        return self.rawValue
    }
}

public class MockSession: URLSessionProtocol {

    private let data: Data

    public init(jsonData: Data) {
        self.data = jsonData
    }

    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        guard let url = request.url else {
            completionHandler(nil, nil, MockError.mockURLFailed); return MockDataTask()
        }
        let response = MockHTTPURLResponse(url: url, method: request.httpMethod)
        completionHandler(data, response, nil)
        return MockDataTask()
    }
}

public class MockDataTask: URLSessionDataTaskProtocol {
    public func resume() {
    }
}

internal class MockHTTPURLResponse: HTTPURLResponse {

    init?(url: URL, method: String?) {
        super.init(url: url, statusCode: 200, httpVersion: method ?? "GET", headerFields: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
