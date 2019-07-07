//
//  QueueManager.swift
//  Avocadough
//
//  Created by SparrowTek on 2/10/19.
//  Copyright © 2019 SparrowTek LLC. All rights reserved.
//

import Foundation

class QueueManager {
    
    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        
        return queue;
    }()
    
    // MARK: - Singleton
    
    static let shared = QueueManager()
    
    // MARK: - Addition
    
    func enqueue(_ operation: Operation) {
        queue.addOperation(operation)
    }
}
