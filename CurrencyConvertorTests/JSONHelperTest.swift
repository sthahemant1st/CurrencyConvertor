//
//  JSONHelperTest.swift
//  CurrencyConvertorTests
//
//  Created by Hemant Shrestha on 11/09/2023.
//

import XCTest
@testable import CurrencyConvertor

final class JSONHelperTest: XCTestCase {

    func test_convert_returnsDecoded() {
        let response = try? JSONHelper.convert(
            name: "RateResponse",
            type: RateResponse.self,
            in: Bundle(for: Self.self)
        )
        XCTAssertNotNil(response)
    }
    
    func test_convert_decodingError() {
        XCTAssertThrowsError(
            _ = try JSONHelper.convert(
                name: "RateResponse",
                type: ErrorModel.self,
                in: Bundle(for: Self.self)
            )
        ) { error in
            XCTAssertTrue(error is JSONHelperError)
        }
    }
    
    func test_convert_fileNotFoundError() {
        XCTAssertThrowsError(
            _ = try JSONHelper.convert(
                name: "Hemant",
                type: RateResponse.self,
                in: Bundle(for: Self.self)
            )
        ) { error in
            XCTAssertTrue(error is JSONHelperError)
            XCTAssertEqual(
                error as? JSONHelperError,
                .fileNotFound(fileName: "Hemant")
            )
        }
    }
    
}
