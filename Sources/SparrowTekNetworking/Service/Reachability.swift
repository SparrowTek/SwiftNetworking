//
//  Reachability.swift
//  Avocadough
//
//  Created by Thomas Rademaker on 2/25/19.
//  Copyright © 2019 SparrowTek LLC. All rights reserved.
//

import Network

enum ReachabiltyStatus {
    case notReachable
    case unknown
    case reachableEithernetOrWifi
    case reachableWWAN
}

protocol ReachabilityDelegate: AnyObject {
    func reachabiltyStatusChange(reachabilityStatus status: ReachabiltyStatus)
}

@available(iOS 12.0, *)
class Reachability {
    private let pathMonitor = NWPathMonitor()
    var delegate: ReachabilityDelegate?
    
    init() {
        monitor()
    }
    
    private func monitor() {
        
        pathMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                if path.isExpensive {
                    print("The network is reachable over the WWAN connection")
                    self.delegate?.reachabiltyStatusChange(reachabilityStatus: .reachableWWAN)
                } else {
                    print("The network is reachable over the WiFi connection")
                    self.delegate?.reachabiltyStatusChange(reachabilityStatus: .reachableEithernetOrWifi)
                }
            } else {
                print("The network is not reachable")
                self.delegate?.reachabiltyStatusChange(reachabilityStatus: .notReachable)
            }
        }
        
        let queue = DispatchQueue(label: "ReachabilityMonitor")
        pathMonitor.start(queue: queue)
    }
}
