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
        XCTAssertEqual(viewModel.selectedCurrency, "")
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
    
    func test_getRates_whenSuccess_selectedCurrencyShouldBeSetToOneOfRatesCountry() async {
        _ = await viewModel.getRates()
        XCTAssertTrue(
            viewModel
                .rates.contains(where: {
                    $0.key == viewModel.selectedCurrency
                })
        )
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
    
    func test_onChangeOfSelectedCurrency_shouldReCalculateRates() async {
        // Given
        _ = await viewModel.getRates()
        // when
        for _ in 0..<5 {
            let previousSelectedCurrency = viewModel.selectedCurrency
            let previousCalculatedRates = viewModel.calculatedRates
            
            viewModel.selectedCurrency = viewModel.calculatedRates.randomElement()!.county
            

            if previousSelectedCurrency != viewModel.selectedCurrency {
                XCTAssertNotEqual(
                    previousCalculatedRates,
                    viewModel.calculatedRates,
                    "previous calculatedRates and present calculatedRates should not be equal"
                )
            } else {
                XCTAssertEqual(
                    previousCalculatedRates,
                    viewModel.calculatedRates,
                    "previous calculatedRates and present calculatedRates should be equal"
                )
            }
        }
    }
    
    func test_onChangeOfValidAmount_shouldReCalculateRates_andAmountShouldBeNil() async {
        _ = await viewModel.getRates()
        
        let previousAmount = viewModel.amount
        let previousCalculatedRates = viewModel.calculatedRates
        
        viewModel.amount = Int.random(in: 1...1000).description
        await Task.sleep(second: 1)
        XCTAssertNil(viewModel.amountErrorMsg)
        if previousAmount != viewModel.amount {
            XCTAssertNotEqual(
                previousCalculatedRates,
                viewModel.calculatedRates,
                "previous calculatedRates and present calculatedRates should not be equal"
            )
        } else {
            XCTAssertEqual(
                previousCalculatedRates,
                viewModel.calculatedRates,
                "previous calculatedRates and present calculatedRates should be equal"
            )
        }
    }
    
    func test_onChangeOfAmountToEmpty_amountErrorMsgShouldBeSet() async {
        _ = await viewModel.getRates()
        
        viewModel.amount = Int.random(in: 1...1000).description
        viewModel.amount = ""
        await Task.sleep(second: 1)
        XCTAssertNotNil(viewModel.amountErrorMsg)
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
