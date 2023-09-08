//
//  CalculatedRate.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 08/09/2023.
//

import Foundation

struct CalculatedRate {
    let county: String
    let amount: Double
}
// MARK: Identifiable
extension CalculatedRate: Identifiable {
    var id: String { county }
}
// MARK: Comparable
extension CalculatedRate: Comparable {
    static func < (lhs: CalculatedRate, rhs: CalculatedRate) -> Bool {
        lhs.county < rhs.county
    }
}
