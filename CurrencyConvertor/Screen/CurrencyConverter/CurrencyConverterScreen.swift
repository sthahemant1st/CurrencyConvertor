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

    // handle viewModel.error
    // handle viewModel.isRefreshing
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Enter amount to convert:")
                    .font(.callout)
                TextField("Amount", text: $viewModel.amount)
                    .textFieldStyle(.roundedBorder)
            }
            // add Currency Picker
            
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
        .navigationTitle("Currency Converter")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.getRates()
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

extension Double {
    func roundedString(_ places: Int = 3) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = places
        return numberFormatter.string(from: NSNumber(value: self)) ?? "--"
    }
}
