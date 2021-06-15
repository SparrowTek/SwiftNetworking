# SparrowTekNetworking

This framework is designed to bring a protocol oriented approach and `Operation` to networking with `URLSession`.  

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

## Sample network request
```swift
func signup(email: String) {
    let router = NetworkRouter<AuthAPI>()
    router.request(.signup(email: email)) { [weak self] result in
        switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let auth = try? decoder.decode(Auth.self, from: data) {
                    // do something with auth object
                }
                
            case .failure(let error):
                // handle error
        }
    }
}
```

This framework is **Heavily** influenced by  
- ["Writing a Network Layer in Swift: Protocol-Oriented Approach"](https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908) by Malcolm Kumwenda  
- [Building a networking layer with operations](https://williamboles.me/building-a-networking-layer-with-operations/) by William Boles

