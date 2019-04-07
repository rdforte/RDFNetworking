# RDFNetworking
### Testing + Networking made Easy.

## About
RDFNetworking is a wrapper of URLSession that deals with JSON and is constructed in a simplistic and easy to implement format, making networking requests a breeze. The framework has been constructed in a generic manner allowing for quick and easy implementation and more advanced implementation for larger scale projects.
RDFNetworking also wraps URLSession and URLSessionDataTask to allow you to run Unit Tests with no network latency, resulting in a framework that is easily testable and quick to implement.

## Installation
### Cocoapods
```
pod 'RDFNetworking', :git => 'https://github.com/rdforte/RDFNetworking.git'
```

## Basic implementation
1. Configure RDFNetworking with URLSession instance.
2. Structure your request with a APIRequest object.
3. Perform your Request.

```
import RDFNetworking

let networking = RDFNetworking(session: URLSession.shared)

let parameters: Parameters = [
    "email": "Ryan@tester55.com",
    "password": "testing12",
    "type": "business",
    "firstName": "Ryan",
    "lastName": "Forte",
    "phone": "0426252825"
]

let headers: Headers = ["Content-Type": "application/json"]
let path = "https://Testing/api/v1/auth/signup"
let request = APIRequest(method: .post, path: path, parameters: parameters, headers: headers)

 networking.performRequest(expectingType: User.self, withRequest: request) { (result) in
    switch result {
    case .success(let auth):
        print(auth)
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```
The performRequest method takes a type of type Codable which represents the response object that you will be expecting to get back from your network request. 

## Custom JSONDecoder Option
The performRequest method also has the ability to take a custom JSONDecoder object allowing you with more flexiblity when decoding your response data.

```
import RDFNetworking

let customDecoder = JSONDecoder()
customDecoder.dateDecodingStrategy = .iso8601

 networking.performRequest(expectingType: User.self, withRequest: request, decoder: customDecoder) { (result) in
    switch result {
    case .success(let auth):
        print(auth)
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```
