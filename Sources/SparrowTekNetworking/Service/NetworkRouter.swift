//
//  NetworkRouter.swift
//  Avocadough
//
//  Created by Thomas Rademaker on 2/10/19.
//  Copyright © 2019 SparrowTek. All rights reserved.
//

import Foundation
import Combine

public protocol NetworkRouterProtocol: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping ((_ result: Result<Data, NetworkError>) -> Void)) -> UUID
    func cancel(_ uuid: UUID)
    
    // Combine
    func request<T: ResponseObject>(_ route: EndPoint) -> AnyPublisher<T, Never>
}

public protocol ResponseObject: Codable {
    associatedtype T
    static func emptyImplementation() -> T
}

public enum NetworkError : Error {
    case encodingFailed
    case missingURL
    case networkError(data: Data?)
    case statusCode
    case noData
}

public typealias HTTPHeaders = [String:String]

public class NetworkRouter<EndPoint: EndPointType>: NetworkRouterProtocol {
    
    let urlSession: URLSession
    let reachability: Reachability
    
    public init() {
        urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        reachability = Reachability()
        reachability.delegate = self
    }
    
    public init(with urlSessionDelegate: URLSessionDelegate) {
        urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: urlSessionDelegate, delegateQueue: nil)
        reachability = Reachability()
        reachability.delegate = self
    }
    
    @discardableResult
    public func request(_ route: EndPoint, completion: @escaping ((_ result: Result<Data, NetworkError>) -> Void)) -> UUID {
        do {
            let request = try buildRequest(from: route)
            NetworkLogger.log(request: request)
            
            let uuid = UUID()
            let operation = ConcurrentOperation(with: request, uuid: uuid)
            operation.completionHandler = completion
            QueueManager.shared.enqueue(operation)
            return uuid
        } catch {
            completion(.failure(.networkError(data: nil)))
            return UUID()
        }
    }
    
    public func cancel(_ uuid: UUID) {
        guard let operations = QueueManager.shared.queue.operations as? [ConcurrentOperation] else { return }
        for operation in operations {
            if operation.uuid == uuid {
                operation.cancel()
                return
            }
        }
    }
    
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                addAdditionalHeaders(route.headers, request: &request)
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                addAdditionalHeaders(route.headers, request: &request)
                try configureParameters(bodyParameters: bodyParameters,
                                        bodyEncoding: bodyEncoding,
                                        urlParameters: urlParameters,
                                        request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    private func configureParameters(bodyParameters: Parameters?,
                                     bodyEncoding: ParameterEncoding,
                                     urlParameters: Parameters?,
                                     request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}

// MARK: Combine
extension NetworkRouter {
    public func request<T: ResponseObject>(_ route: EndPoint) -> AnyPublisher<T, Never> {
        do {
            let request = try buildRequest(from: route)
            #if DEBUG
            NetworkLogger.log(request: request)
            #endif
            return sendRequest(request)
        } catch {
            #warning("BIG RED FLAG!! forced unwrapped optional")
            return Just(T.emptyImplementation() as! T)
            .eraseToAnyPublisher()
        }
    }
    
    private func sendRequest<T: ResponseObject>(_ urlRequest: URLRequest) -> AnyPublisher<T, Never> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        #warning("BIG RED FLAG!! forced unwrapped optional")
        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw NetworkError.statusCode
                }
                return output.data
        }
        .decode(type: T.self, decoder: decoder)
        .replaceError(with: T.emptyImplementation() as! T)
            .eraseToAnyPublisher()
    }
}

extension NetworkRouter: ReachabilityDelegate {
    func reachabiltyStatusChange(reachabilityStatus status: ReachabiltyStatus) {
        let notificationCenter = NotificationCenter.default
        
        switch status {
        case .notReachable:
            notificationCenter.post(name: .reachabilityNotReachable, object: nil)
        case .unknown:
            notificationCenter.post(name: .reachabilityUnknown, object: nil)
        case .reachableEithernetOrWifi:
            notificationCenter.post(name: .reachabilityReachableEithernetOrWifi, object: nil)
        case .reachableWWAN:
            notificationCenter.post(name: .reachabilityReachableWWAN, object: nil)
        }
    }
}
