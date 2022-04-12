//
//  Throttler.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//

import Foundation

class Throttler {
    typealias Operation = () -> Void
    private let delayTime: TimeInterval
    private var lastFireTime: Date = Date(timeIntervalSince1970: 0)
    init(delay: TimeInterval) {
        self.delayTime = delay
    }
    func perform(_ operation: Operation, notperformCompletion: (() -> Void)? = nil) {
        let now = Date()
        if now.timeIntervalSince(lastFireTime) > delayTime {
            operation()
            lastFireTime = now
        } else {
            notperformCompletion?()
        }
    }
}
