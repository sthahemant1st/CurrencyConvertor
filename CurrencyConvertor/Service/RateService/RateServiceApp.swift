//
//  RateServiceLocal.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 08/09/2023.
//

import Foundation

struct RateServiceApp: RateService {
    func getLatestRate() async throws -> RateResponse {
        let savedRateResponse = PersistenceHelper.getRateResponse()
        
        // check if there is internet
        guard NetworkReachableMonitor.shared.isReachable else {
            if let savedRateResponse {
                return savedRateResponse
            } else {
                throw APIError.transportError
            }
        }
        
        // check if savedRateResponse exceeds fetch interval
        if let savedRateResponse {
            let fetchedDate = Date(timeIntervalSince1970: savedRateResponse.timestamp)
            let timeInterval = fetchedDate.timeIntervalSinceNow
            print("timeInterval: \(timeInterval)")
            if timeInterval.intValue.absoluteValue < AppConstant.rateFetchInterval {
                return savedRateResponse
            }
        }
        
        var response = try await RateServiceNetwork.shared.getLatestRate()
        
        // persist with timeStamp according to device
        response.timestamp = Date().timeIntervalSince1970
        try? PersistenceHelper.saveRateResponse(response)
        
        return response
    }
    
}

extension SignedNumeric where Self: Comparable {
    var absoluteValue: Self { abs(self) }
}
