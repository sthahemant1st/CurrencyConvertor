//
//  NetworkReachableMonitor.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 08/09/2023.
//

import Foundation
import Network

class NetworkReachableMonitor {
    static let shared: NetworkReachableMonitor = .init()
    var isReachable: Bool = false
    
    private let monitor: NWPathMonitor
    
    private init() {
        self.monitor = NWPathMonitor()
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isReachable = true
            } else {
                self.isReachable = false
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
