//
//  CurrencyConverterViewModelTest.swift
//  CurrencyConvertorTests
//
//  Created by Hemant Shrestha on 09/09/2023.
//

import XCTest
@testable import CurrencyConvertor

final class CurrencyConverterViewModelTest: XCTestCase {

//    private var sUT: CurrencyConverterViewModel!
    
    @MainActor 
    override func setUpWithError() throws {
//        sUT = .init()
    }

    override func tearDownWithError() throws {
//        sUT = nil
    }

    @MainActor
    func test_initialization_everyPropertiesInitializedProperly() {
        // given
        let viewModel: CurrencyConverterViewModel
        // when
        viewModel = CurrencyConverterViewModel()
        // then
        XCTAssertTrue(viewModel.rates.isEmpty)
        XCTAssertEqual(viewModel.amount, "100")
        XCTAssertEqual(viewModel.selectedCurrency, "USD")
        XCTAssertTrue(viewModel.calculatedRates.isEmpty)
        XCTAssertNil(viewModel.amountErrorMsg)
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.isRefreshing)
    }

}

// testing async/await
// https://www.avanderlee.com/concurrency/unit-testing-async-await/

// test extension
// test userDefaults
// test thrown error type
// https://www.avanderlee.com/swift/unit-tests-best-practices/
