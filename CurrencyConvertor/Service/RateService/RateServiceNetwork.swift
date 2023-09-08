//
//  RateServiceNetwork.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 08/09/2023.
//

import Foundation

struct RateServiceNetwork: RateService {
    static let shared: RateServiceNetwork = .init()
    private init() {}
    
    private var networkCaller = NetworkCaller.shared
    
    // MARK: EndPoints
    private var latestRateEndPoint = Endpoint(
        path: "/api/latest.json",
        httpMethod: .get
    )
    
    // MARK: Functions
    func getLatestRate() async throws -> RateResponse {
        return try await networkCaller.request(
            withEndPoint: latestRateEndPoint,
            returnType: RateResponse.self
        )
    }
}
