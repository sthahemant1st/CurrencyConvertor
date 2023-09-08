//
//  RateServicePreview.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 08/09/2023.
//

import Foundation

struct RateServicePreview: RateService {
    func getLatestRate() async throws -> RateResponse {
        return try JSONHelper.convert(name: "RateResponse", type: RateResponse.self)
    }
}
