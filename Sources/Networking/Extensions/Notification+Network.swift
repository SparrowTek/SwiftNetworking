//
//  Notification+Network.swift
//
//
//  Created by Thomas Rademaker on 12/20/20.
//  Copyright © 2020 Barstool Sports. All rights reserved.
//

import Foundation

@available(iOS 15.0, macOS 9999, *)
extension Notification.Name {
    
    // MARK: Reachability
    static var reachabilityNotReachable: Notification.Name {
        return .init("Reachability.notReachable")
    }
    
    static var reachabilityUnknown: Notification.Name {
        return .init("Reachability.unknown")
    }
    
    static var reachabilityReachableEithernetOrWifi: Notification.Name {
        return .init("Reachability.reachableEithernetOrWifi")
    }
    
    static var reachabilityReachableWWAN: Notification.Name {
        return .init("Reachability.reachableWWAN")
    }
}
