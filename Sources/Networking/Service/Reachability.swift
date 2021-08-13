//
//  Reachability.swift
//
//
//  Created by Thomas Rademaker on 12/20/20.
//  Copyright © 2020 Barstool Sports. All rights reserved.
//

import Network

@available(iOS 15.0, macOS 9999, *)
enum ReachabiltyStatus {
    case notReachable
    case unknown
    case reachableEithernetOrWifi
    case reachableWWAN
}

@available(iOS 15.0, macOS 9999, *)
protocol ReachabilityDelegate: AnyObject {
    func reachabiltyStatusChange(reachabilityStatus status: ReachabiltyStatus)
}

@available(iOS 15.0, macOS 9999, *)
class Reachability {
    private let pathMonitor = NWPathMonitor()
    var delegate: ReachabilityDelegate?
    
    init() {
        monitor()
    }
    
    private func monitor() {
        
        pathMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                
                if path.isExpensive {
                    self.delegate?.reachabiltyStatusChange(reachabilityStatus: .reachableWWAN)
                } else {
                    self.delegate?.reachabiltyStatusChange(reachabilityStatus: .reachableEithernetOrWifi)
                }
            } else {
                self.delegate?.reachabiltyStatusChange(reachabilityStatus: .notReachable)
            }
        }
        
        let queue = DispatchQueue(label: "ReachabilityMonitor")
        pathMonitor.start(queue: queue)
    }
}
