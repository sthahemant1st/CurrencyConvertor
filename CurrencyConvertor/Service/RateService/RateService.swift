//
//  RateService.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 08/09/2023.
//

import Foundation

protocol RateService {
    func getLatestRate() async throws -> RateResponse
}
