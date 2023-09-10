//
//  CurrencyConverterViewModelTest.swift
//  CurrencyConvertorTests
//
//  Created by Hemant Shrestha on 09/09/2023.
//

import XCTest
import Combine
@testable import CurrencyConvertor

@MainActor
final class CurrencyConverterViewModelTest: XCTestCase {

    private var viewModel: CurrencyConverterViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        viewModel = .init(rateService: RateServiceMock())
    }

    override func tearDownWithError() throws {
        viewModel = nil
        cancellables.removeAll()
    }

    func test_initialization_everyPropertiesInitializedProperly() {
        // given
        // when
        // then
        XCTAssertTrue(viewModel.rates.isEmpty)
        XCTAssertEqual(viewModel.amount, "100")
        XCTAssertEqual(viewModel.selectedCurrency, "USD")
        XCTAssertTrue(viewModel.calculatedRates.isEmpty)
        XCTAssertNil(viewModel.amountErrorMsg)
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.isRefreshing)
    }
    
    func test_getRates_beforeAwait_isRefreshingIsTrue_andErrorIsNil() async {
        let isRefreshingExpectation = XCTestExpectation(
            description: "Refreshing should be set to true on call of getRates"
        )
        let errorExpectation = XCTestExpectation(
            description: "Error should be set to nil on call of getRates"
        )
        viewModel.$isRefreshing
            .dropFirst()
            .first()
            .sink { isRefreshing in
                if isRefreshing == true {
                    isRefreshingExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.$error
            .dropFirst()
            .first()
            .sink { error in
                if error.isNil {
                    errorExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        _ = await viewModel.getRates()
        
        await fulfillment(of: [isRefreshingExpectation, errorExpectation], timeout: 0.1)
        
    }
    
    func test_getRates_afterAwait_isRefreshingIsReset() async {
        // given
        // when
        _ = await viewModel.getRates()
        XCTAssertFalse(viewModel.isRefreshing)
    }
    
    func test_getRates_whenSuccess_ratesIsSet() async {
        XCTAssertTrue(viewModel.rates.isEmpty)
        _ = await viewModel.getRates()
        XCTAssertGreaterThan(viewModel.rates.count, 0)
    }
    
    func test_getRates_whenSuccess_calculatedRatesIsSetAndIsSorted() async {
        XCTAssertTrue(viewModel.calculatedRates.isEmpty)
        _ = await viewModel.getRates()
        XCTAssertGreaterThan(viewModel.calculatedRates.count, 0)
        XCTAssertEqual(viewModel.calculatedRates, viewModel.calculatedRates.sorted())
    }
    
    func test_getRates_onFailure_errorShouldBeUpdated() async {
        viewModel = CurrencyConverterViewModel(rateService: RateServiceMockFailure())
        _ = await viewModel.getRates()
        XCTAssertNotNil(viewModel.error)
    }
}

class RateServiceMock: RateService {
    func getLatestRate() async throws -> CurrencyConvertor.RateResponse {
        await Task.sleep(second: 1)
        return try JSONHelper.convert(name: "RateResponse", type: RateResponse.self)
    }
}

class RateServiceMockFailure: RateService {
    func getLatestRate() async throws -> CurrencyConvertor.RateResponse {
        throw DummyError()
    }
}

struct DummyError: LocalizedError {
    var errorDescription: String? { "This is Dummy Error" }
}

// testing async/await
// https://www.avanderlee.com/concurrency/unit-testing-async-await/

// test extension
// test userDefaults
// test thrown error type
// https://www.avanderlee.com/swift/unit-tests-best-practices/
