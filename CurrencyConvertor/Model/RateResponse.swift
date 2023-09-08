//
//  RateResponse.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 08/09/2023.
//

import Foundation

struct RateResponse: Codable {
    let disclaimer: String
    let license: String
    var timestamp: Double
    let base: String
    let rates: [String: Double]
}
