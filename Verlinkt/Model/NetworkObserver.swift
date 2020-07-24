//
//  NetworkObserver.swift
//  Tiger
//
//  Created by Henrik Thoroe on 19.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import Foundation
import Network

class NetworkObserver {
    
    static let shared = NetworkObserver()
    
    private(set) public var isConnected: Bool = false
    
    private let monitor: NWPathMonitor
    
    private let queue: DispatchQueue
    
    private init() {
        queue = DispatchQueue(label: "Network Monitor")
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            print(path.status)
            self.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
        
        print("Init NO")
    }
    
}
