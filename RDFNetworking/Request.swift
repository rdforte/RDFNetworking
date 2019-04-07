//
//  Request.swift
//  RDFNetworking
//
//  Created by ryan del forte on 5/4/19.
//  Copyright © 2019 ryan del forte. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]
public typealias Headers = [String: String]

public protocol Request {
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: Headers? { get }
    var parameters: Parameters? { get }
}

public extension Request {
    var headers: Headers? { return nil }
    var parameters: Parameters? { return nil }
}

public class APIRequest: Request {
    public var method: HTTPMethod
    public var path: String
    public var headers: Headers?
    public var parameters: Parameters?

    public init(method: HTTPMethod, path: String, parameters: Parameters?, headers: Headers?) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.headers = headers
    }
}
