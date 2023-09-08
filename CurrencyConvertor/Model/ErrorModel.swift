//
//  ErrorModel.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 08/09/2023.
//

import Foundation

struct ErrorModel: Codable {
    let error: Bool
    let status: Int
    let message, description: String
}
