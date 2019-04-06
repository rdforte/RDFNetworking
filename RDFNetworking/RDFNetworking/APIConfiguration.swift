//
//  APIConfiguration.swift
//  Made
//
//  Created by ryan del forte on 5/4/19.
//  Copyright © 2019 ryan del forte. All rights reserved.
//

import Foundation

// MARK: - Response

fileprivate struct APIResponse {
    let statusCode: Int
    let data: Data?
}

// MARK: - Error handling

fileprivate enum APIError: String {
    case invalidURL = "Not a valid URL"
    case requestFailed = "Request Failed"
    case decodingFailure = "Failed to decode data"
    case parameterSerializationFailure = "Expecting to serialize parameters in JSON Format"
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        return self.rawValue
    }
}

fileprivate struct HTTPError: LocalizedError {
    let status: Int

    public var errorDescription: String? {
        return "HTTPResponse status code error: \(status)"
    }
}

// MARK: - Networking

public class RDFNetworking {

    fileprivate typealias APICompletion = (Result<APIResponse>) -> Void

    private let session: URLSessionProtocol
    public static let jsonDecoder: JSONDecoder = JSONDecoder()

    init(session: URLSessionProtocol) {
        self.session = session
    }

    private func perform(_ request: Request, _ completion: @escaping APICompletion) {

        guard let url = URL(string: request.path) else {
            completion(.failure(APIError.invalidURL)); return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        if let paramaters = request.parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: paramaters, options: .prettyPrinted)
            } catch {
                completion(Result.failure(APIError.parameterSerializationFailure)); return
            }
        }

        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.requestFailed)); return
            }
            if let error = error {
                completion(Result.failure(error)); return
            }
            completion(.success(APIResponse(statusCode: httpResponse.statusCode, data: data)))
        }

        task.resume()
    }

}

public extension RDFNetworking {

    func performRequest<T: Decodable>(expectingType type: T.Type, withRequest request: Request, decoder: JSONDecoder = jsonDecoder, completion: @escaping (Result<T>) -> Void) {
        perform(request) { (result) in
            switch result {
            case .success(let apiResponse):
                if apiResponse.statusCode == 200, let data = apiResponse.data {
                    do {
                        let object = try decoder.decode(T.self, from: data)
                        completion(Result.success(object))
                    } catch {
                        completion(Result.failure(error))
                    }
                } else {
                    completion(Result.failure(HTTPError(status: apiResponse.statusCode)))
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }

}
