# Networking

An enum conforming the `EndpointType` protocol is needed to create the endpoints that your app will be using.

## EndpointType Example:
```swift
enum AuthAPI {
    case signup(email: String)
    case login(email: String, password: String)
    case getData
}

extension AuthAPI: EndpointType {
    static let baseURLPath = "https://sparrowtek.com"

    var path: String {
        switch self {
        case .signup:
            return "account/signup"
        case .login:
            return "account/login"
        case .getData:
            return "data"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
            case .signup, .login,
                return .post
            case .getData:
                return .get
        }
    }

    var task: HTTPTask {
        switch self {
            case .signup(let email):
                return .requestParameters(bodyParameters: ["email" : email],
                        bodyEncoding: .jsonEncoding,
                        urlParameters: nil)
            case .login(let email, let password):
                return .requestParameters(bodyParameters: ["email" : email,
                        "password" : password],
                        bodyEncoding: .jsonEncoding,
                        urlParameters: nil)
            default:
                return nil
        }
    }

    var headers: HTTPHeaders? {
        switch self {
            case .signup:
                return ["x-access-token" : "accessToken"]
        default:
            return nil
        }
    }
}
```

With your `EndpointType` implemented you can make network requests using a Provider class.

## Provider example

```swift
import Foundation
import Combine

protocol AuthProviding {
    var router: NetworkRouter<AuthAPI> { get }
    
    func getUser() async throws -> User
}

class AuthProvider: AuthProviding {
    var router: NetworkRouter<AuthAPI>
    
    init(router: NetworkRouter<AuthAPI> = NetworkRouter<AuthAPI>()) {
        self.router = router
    }
    
    func getUser() async throws -> User {
        try await router.execute(AuthAPI.getUser)
    }
}
```


