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
        handleAmountChange()
    }
    
    func getRates() async {
        error = nil
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
        do {
            calculatedRates = try rates.toCalculatedRates(
                selectedCurrency: selectedCurrency,
                enteredAmount: amount.doubleValue
            )
            .sorted()
        } catch {
            fatalError("Should never happen as we have selected currency form rates")
        }
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
