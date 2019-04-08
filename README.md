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
### Current Version
1.0.0

### What to expect in version 1.1.0
- Multipart form data upload

## Basic Implementation
1. Configure RDFNetworking with URLSession instance.
2. Structure your request with a APIRequest object.
3. Perform your Request.

```
import RDFNetworking

let networking = RDFNetworking(session: URLSession.shared)

let parameters: Parameters = [
    "email": "Ryan@test.com",
    "password": "testing12",
    "firstName": "Ryan",
    "lastName": "Forte"
]

let headers: Headers = ["Content-Type": "application/json"]
let path = "https://Testing/api/v1/auth/signup"
let request = APIRequest(method: .post, path: path, parameters: parameters, headers: headers)

 networking.performRequest(expectingType: User.self, withRequest: request) { (result) in
    switch result {
    case .success(let user):
        print(user)
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

## Advanced Usage
The advanced usage allows you to construct an enum that conforms to the Request protocol, resulting in generic code that is more concise, clear and easier to maintain for large scale projects that requre multiple types of networking requests.

```
enum AuthRequest: Request {

    case signUp(email: String, password: String, firstName: String, lastName: String)
    case signIn(email: String, password: String)

    var method: HTTPMethod {
        switch self {
        case .signUp, .signIn:
            return .post
        }
    }

    var path: String {
        switch self {
        case .signUp:
            return "https://Tester/api/v1/auth/signup"
        case .signIn:
            return "https://Tester/api/v1/auth/signin"
        }
    }

    var headers: Headers? {
        switch self {
        case .signUp, .signIn:
            return ["Content-Type": "application/json"]

        }
    }

    var parameters: Parameters? {
        switch self {
        case .signUp(let email, let password, let firstName, let lastName):
            return [
                "email": email,
                "password": password,
                "firstName": firstName,
                "lastName": lastName
            ]
        case .signIn(let email, let password):
            return [
                "email": email,
                "password": password
            ]
        }
    }

}
```
Once we have constructed our enum and conformed to all the necessary properties it is just a matter of then feeding our request to our performRequest method. For example:

```
let singInRequst = AuthRequest.signIn(email: "test@test.com", password: "test")

 networking.performRequest(expectingType: User.self, withRequest: signInRequest) { (result) in
    switch result {
    case .success(let auth):
        print(auth)
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```

## Unit Tests
RDFNetworking creates a wrapper aroung URLSession and URLSessionDataTask allowing for easy testing of networking with no network latency. The steps to perfomr your tests are as follows:
1. structure your RDFNetworking with an instance of MockSession.
2. MockSession takes data in the form of JSON. This is the JSON that you will be expecting to get back in your response.
3. perform your request with the performRequest method with the appropriate type you are expecting in your response and custom 
    decoder object if needed for decoding the JSON data.
4. Perform the appropriate checks to make sure you get the response you are looking for.

```
MockUser.js file

{
"id": "5ca70f09077c40001c0fffbc",
"firstName": "Ryan",
"lastName": "Forte"
}

```
Above is an example of a file containing a JSON object which I will convert to data and feed to my MockSession Instance.
Note: You do not have to perform your unit test this way, I just prefer to do it this way for ease of use and clarity.

```
  func testNetworking() {
        // configure request
        let path = "https://dev.test.com"
        let request = APIRequest(method: .post, path: path, parameters: nil, headers: nil)
        
        //retrieve json data from local file
        guard let userPath = Bundle.main.path(forResource: "MockUser", ofType: "js") else {
            XCTAssert(false, "path should exist for resource MockUser"); return
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: userPath), options: .mappedIfSafe) else {
            XCTAssert(false, "data from MockUser.js should convert to Data"); return
        }
        
        // configure mock session with mock data
        let session = MockSession(jsonData: data)
        let networking = RDFNetworking(session: session)
        
        // test networking request with mock session
        networking.performRequest(expectingType: MockUser.self, withRequest: request) { (result) in
            switch result {
            case .success(let user):
                XCTAssertNotNil(user, "user object should not be nil")
            case .failure(let error):
                XCTAssert(false, "test should not reach error: \(error.localizedDescription)")
            }
        }

    }
```
If all goes well your test should succeed.
