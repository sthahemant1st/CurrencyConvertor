//
//  Task+Extension.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 10/09/2023.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    
    static func sleep(second duration: Double) async {
        try? await sleep(nanoseconds: UInt64(duration * 1_000_000_000))
    }
}
