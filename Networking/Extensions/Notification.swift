//
//  Notification.swift
//  Avocadough
//
//  Created by Thomas Rademaker on 11/18/18.
//  Copyright © 2018 SparrowTek LLC. All rights reserved.
//

import Foundation

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
