//
//  CurrencyConverterViewModel.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 06/09/2023.
//

import Foundation

@MainActor
class CurrencyConverterViewModel: BaseViewModel {
    private let rateService: RateService
    
    private var rateResponse: RateResponse?
    
    @Published var amount = "100"
    @Published var selectedCurrency = ""
    @Published var calculatedRates: [CalculatedRate] = []
    
    init(
        rateService: RateService = RateServiceNetwork.shared
    ) {
        self.rateService = rateService
        selectedCurrency = "USD" // selectedCurrency can be saved in UserDefaults

    }
    
    func getRates() async {
        isRefreshing = true
        do {
            let response = try await rateService.getLatestRate()
            rateResponse = response
            // if response.rates.isEmpty throw error
            calculateRates()
        } catch {
            self.error = error
        }
    }
    
    // should be called in amount change, selectedCountry change and rateFetch
    private func calculateRates() {
        guard let rates = rateResponse?.rates else {
            return
        }
        calculatedRates = rates.map({ country, rate in
            return CalculatedRate(county: country, amount: rate * amount.doubleValue)
        })
        .sorted()
    }
}

extension String {
    var doubleValue: Double { Double(self) ?? 0 }
}

@MainActor
class BaseViewModel: ObservableObject {
    @Published var isRefreshing: Bool = false
    @Published var error: Error?
}
// TODO: add swiftLint
