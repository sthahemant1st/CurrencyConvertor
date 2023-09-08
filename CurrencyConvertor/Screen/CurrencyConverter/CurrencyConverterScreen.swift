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
    
    // TODO: add baseView
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Enter amount to convert:")
                        .font(.callout)
                    TextField("Amount", text: $viewModel.amount)
                        .textFieldStyle(.roundedBorder)
                }
                // add Currency Picker
                // last fetched text using rateResponse.timestamp
                ScrollView {
                    ForEach(viewModel.calculatedRates) { item in
                        HStack {
                            Text(item.county + " ")
                            Text(item.amount.roundedString())
                            Spacer()
                        }
                        .monospaced()
                    }
                    
                }
                
            }
            .padding(16.0)
            
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
