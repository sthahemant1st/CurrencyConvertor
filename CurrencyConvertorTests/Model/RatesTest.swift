//
//  RatesTest.swift
//  CurrencyConvertorTests
//
//  Created by Hemant Shrestha on 11/09/2023.
//

import XCTest
@testable import CurrencyConvertor

final class RatesTest: XCTestCase {
    let rates = [
        "USD": 1,
        "NPR": 130,
        "INR": 130 / 1.6
    ]
    
    func test_toCalculateRates_whenAmountSameAsRates_containsAllConvertedRates_andconvertedRatesSimilarToRates() throws {
        
        let calculatedRates = try rates.toCalculatedRates(
            selectedCurrency: "NPR",
            enteredAmount: 130
        )
        
        XCTAssertEqual(rates.count, calculatedRates.count)
        
        for calculatedRate in calculatedRates {
            XCTAssertTrue(rates.contains(where: { $0.key == calculatedRate.county }))
            
            XCTAssertEqual(rates[calculatedRate.county], calculatedRate.amount)
        }
    }
    
    func test_toCalculatedRates_whenAmountOne_shouldReturnConvertedProperly() throws {
        
        let calculatedRates = try rates.toCalculatedRates(
            selectedCurrency: "NPR",
            enteredAmount: 1
        )
        
        for calculatedRate in calculatedRates {
            XCTAssertEqual(
                calculatedRate.amount,
                rates[calculatedRate.county]! / rates["NPR"]!
            )
        }
    }
    
    func test_toCalculatedRates_throwsCurrencyNotFound() {
        XCTAssertThrowsError(
            _ = try rates.toCalculatedRates(
                selectedCurrency: "AUS",
                enteredAmount: 130
            )
        ) { error in
            XCTAssert(error is Rates.RateCalculationError)
            XCTAssertEqual(error as? Rates.RateCalculationError, .currencyNotFound)
        }
    }
    
}
