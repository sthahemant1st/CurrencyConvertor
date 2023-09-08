//
//  RateServiceLocal.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 08/09/2023.
//

import Foundation

struct RateServiceLocal: RateService {
    func getLatestRate() async throws -> RateResponse {
        let response = PersistenceHelper.getRateResponse()
        
        guard let response else {
            throw 
        }
    }
}
