//
//  ConcurrentOperation.swift
//  Avocadough
//
//  Created by Thomas Rademaker on 2/10/19.
//  Copyright © 2019 SparrowTek. All rights reserved.
//

import Foundation

class ConcurrentOperation: Operation {
    
    typealias OperationCompletionHandler = (_ result: Result<Data, NetworkError>) -> Void
    
    var completionHandler: (OperationCompletionHandler)?
    
    private let session: URLSession
    private let urlRequest: URLRequest
    private var task: URLSessionTask?
    
    var uuid: UUID
    
    init(with urlRequest: URLRequest, uuid: UUID, session: URLSession = URLSession.shared) {
        self.session = session
        self.urlRequest = urlRequest
        self.uuid = uuid
    }
    
    override func main() {
        
        task = session.dataTask(with: urlRequest) { (data, response, error) in
            NetworkLogger.log(data: data, response: response, error: error)
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.complete(result: .failure(.networkError(data: nil)))
                }
                
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.complete(result: .failure(.noData))
                }
                return
            }
            
            DispatchQueue.main.async {
                let status = httpResponse.statusCode
                
                switch status {
                case 200...299:
                    self.complete(result: .success(data))
                default:
                    #warning("handle individual status codes differently")
                    self.complete(result: .failure(.networkError(data: data)))
                }
            }
        }
        
        task?.resume()
    }
    
    // MARK: - State
    
    private enum State: String {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
    }
    
    private var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: state.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    // MARK: - Start
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        
        if !isExecuting {
            state = .executing
        }
        
        main()
    }
    
    // MARK: - Finish
    
    func finish() {
        if isExecuting {
            state = .finished
        }
    }
    
    func complete(result: Result<Data, NetworkError>) {
        finish()
        
        if !isCancelled {
            completionHandler?(result)
        }
    }
    
    // MARK: - Cancel
    
    override func cancel() {
        task?.cancel()
        super.cancel()
        
        finish()
    }
}
