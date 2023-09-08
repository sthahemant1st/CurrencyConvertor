//
//  CurrencyConverterViewModel.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 06/09/2023.
//

import Foundation
import Combine

@MainActor
class CurrencyConverterViewModel: BaseViewModel {
    private let rateService: RateService
    
    var rates: [String: Double] = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var amount = "100"
    @Published var selectedCurrency = ""
    @Published var calculatedRates: [CalculatedRate] = []
    
    @Published var amountErrorMsg: String?
    
    init(
        rateService: RateService = RateServiceApp()
    ) {
        self.rateService = rateService
        super.init()
        selectedCurrency = "USD" // selectedCurrency can be saved in UserDefaults
        // add validation
        handleAmountChange()
    }
    
    func getRates() async {
        isRefreshing = true
        do {
            let response = try await rateService.getLatestRate()
            rates = response.rates
            calculateRates()
        } catch {
            self.error = error
        }
        isRefreshing = false
    }
    
    // should be called in amount change, selectedCountry change and rateFetch
    private func calculateRates() {
        let oneUSDToSelectedCountry = rates[selectedCurrency]
        guard let oneUSDToSelectedCountry else {
            fatalError("This condition should never occur")
        }
        let selectedCurrencyAmountToUSD = 1 / oneUSDToSelectedCountry * amount.doubleValue
        
        calculatedRates = rates.map({ country, rate in
            return CalculatedRate(county: country, amount: rate * selectedCurrencyAmountToUSD)
        })
        .sorted()
    }
    
    private func handleAmountChange() {
        $amount
            .dropFirst()
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { amount in
                self.amountErrorMsg = amount.isEmpty ? "Amount field is empty." : nil
                self.calculateRates()
            }
            .store(in: &cancellables)
    }
}
