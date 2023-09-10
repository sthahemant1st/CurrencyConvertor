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
    let rates: Rates
}

typealias Rates = [String: Double]

extension Rates {
    func toCalculatedRates(
        selectedCurrency: String,
        enteredAmount: Double
    ) throws -> [CalculatedRate] {
        let oneUSDToSelectedCountry = self[selectedCurrency]
        guard let oneUSDToSelectedCountry else {
            throw RateCalculationError.currencyNotFound
        }
        let selectedCurrencyAmountToUSD = 1 / oneUSDToSelectedCountry * enteredAmount
        
        return self.map({ country, rate in
            return CalculatedRate(
                county: country,
                amount: rate * selectedCurrencyAmountToUSD
            )
        })
    }
    
    enum RateCalculationError: Error {
        case currencyNotFound
    }
}
