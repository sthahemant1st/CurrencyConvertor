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
                VStack(alignment: .leading, spacing: 16) {
                    amountField
                        
                    countryPicker
                    
                    Text("Converted Amount:")
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                if let amountErrorMsg = viewModel.amountErrorMsg {
                    Text(amountErrorMsg)
                        .foregroundStyle(.red)
                        
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
        .onViewDidLoad(perform: getRates)
    }
    
    private func getRates() {
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
                .font(.footnote)
            TextField("Enter amount to convert:", text: $viewModel.amount)
                .textFieldStyle(.roundedBorder)
        }
        .foregroundStyle(Color.appText)
    }
    
    var countryPicker: some View {
        Picker(
            "Select Currency:",
            selection: $viewModel.selectedCurrency
        ) {
            ForEach(viewModel.rates.keys.sorted(), id: \.self) { currency in
                Text(currency)
            }
        }
        .pickerStyle(.navigationLink)
        .tint(.appPrimary)
    }
    
    var calculatedRatesView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                
                ForEach(viewModel.calculatedRates) { item in
                    HStack {
                        Text("\(item.county) ")
                        Text(item.amount.roundedString())
                        Spacer()
                    }
                    .monospaced()
                    Divider()
                }
            }
            .padding(.horizontal, 16)
            .foregroundStyle(Color.appText)
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
                action: getRates
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
