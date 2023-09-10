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
    @Published var selectedCurrency = "" {
        didSet {
            if oldValue != selectedCurrency {
                self.calculateRates()
                // selectedCurrency can be saved in UserDefaults
            }
        }
    }
    @Published var calculatedRates: [CalculatedRate] = []
    
    @Published var amountErrorMsg: String?
    
    init(
        rateService: RateService = RateServiceApp()
    ) {
        self.rateService = rateService
        super.init()
        
        handleAmountChange()
    }
    
    func getRates() async {
        error = nil
        isRefreshing = true
        do {
            let response = try await rateService.getLatestRate()
            rates = response.rates
            
            guard !rates.isEmpty else {
                throw CustomError(description: "rates is empty")
            }
            selectedCurrency = rates.first(where: { $0.key == "USD"})?.key
            ?? rates.randomElement()!.key
        } catch {
            self.error = error
        }
        isRefreshing = false
    }
    
    // should be called in amount change, selectedCountry change and rateFetch
    private func calculateRates() {
        guard !selectedCurrency.isEmpty else { return }
        
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
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { amount in
                self.amountErrorMsg = amount.isEmpty ? "Amount field is empty." : nil
                self.calculateRates()
            }
            .store(in: &cancellables)
    }
}

struct CustomError: LocalizedError {
    let description: String
    init(description: String) {
        self.description = description
    }
    
    var errorDescription: String? { description }
    
    static let dummyError: CustomError = .init(description: "This is Dummy Error")
}
