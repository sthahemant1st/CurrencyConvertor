//
//  PersistenceHelperTest.swift
//  CurrencyConvertorTests
//
//  Created by Hemant Shrestha on 11/09/2023.
//

import XCTest
@testable import CurrencyConvertor

final class PersistenceHelperTest: XCTestCase {

    func test_saveRateResponse_getRateResponse_returnsRecentlySavedResponse() throws {
        let toSaveResponse = RateResponse(
            disclaimer: "",
            license: "",
            timestamp: Double.random(in: 1...1000),
            base: "",
            rates: [:]
        )
        try PersistenceHelper.saveRateResponse(toSaveResponse)
        let savedResponse = PersistenceHelper.getRateResponse()
        
        XCTAssertEqual(toSaveResponse.timestamp, savedResponse?.timestamp)
    }

}
