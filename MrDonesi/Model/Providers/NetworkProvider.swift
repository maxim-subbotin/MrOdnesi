//
//  NetworkProvider.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 16.06.2022.
//

import Foundation
import Network
import Combine

class NetworkProvider {
    enum Status {
        case on
        case off
    }
    let monitor = NWPathMonitor()
    
    let subject = PassthroughSubject<Status, Never>()
    
    init() {
        monitor.pathUpdateHandler = { [weak self] pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                print("Internet connection is on.")
                self?.subject.send(.on)
            } else {
                self?.subject.send(.off)
                print("There's no internet connection.")
            }
        }
        let queue = DispatchQueue(label: "network_monitor")
        monitor.start(queue: queue)
    }
}
