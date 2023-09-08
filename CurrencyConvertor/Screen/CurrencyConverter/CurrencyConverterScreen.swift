//
//  CurrencyConverterScreen.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 06/09/2023.
//

import SwiftUI

struct CurrencyConverterScreen: View {
    @StateObject private var viewModel: CurrencyConverterViewModel
    
    init(viewModel: CurrencyConverterViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                amountField
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                countryPicker
                    .padding(.horizontal, 16)
                
                if let amountErrorMsg = viewModel.amountErrorMsg {
                    Text(amountErrorMsg)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 16)
                } else {
                    calculatedRatesView
                }
                
                Spacer()
            }
            
            refreshingView
            
            errorView
        }
        .navigationTitle("Currency Converter")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.getRates()
        }
    }
    
    private func onErrorRetry() {
        Task {
            await viewModel.getRates()
        }
    }
}

// MARK: subViews
private extension CurrencyConverterScreen {
    var amountField: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Enter amount to convert:")
                .font(.callout)
            TextField("Amount", text: $viewModel.amount)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    var countryPicker: some View {
        Picker(
            "Select Currency",
            selection: $viewModel.selectedCurrency
        ) {
            ForEach(viewModel.rates.keys.sorted(), id: \.self) { currency in
                Text(currency)
            }
        }
        .pickerStyle(.navigationLink)
    }
    
    var calculatedRatesView: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.calculatedRates) { item in
                    HStack {
                        Text(item.county + " ")
                        Text(item.amount.roundedString())
                        Spacer()
                    }
                    .monospaced()
                    Divider()
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    var refreshingView: some View {
        if viewModel.isRefreshing {
            Color.black.opacity(0.1)
                .overlay {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            
        }
    }
    
    @ViewBuilder
    var errorView: some View {
        if let error = viewModel.error {
            ErrorRetryView(
                description: error.localizedDescription,
                action: onErrorRetry
            )
            .background(Color.white)
        }
    }
}

struct CurrencyConverterScreen_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverterScreen(
            viewModel: .init(rateService: RateServicePreview())
        )
    }
}
