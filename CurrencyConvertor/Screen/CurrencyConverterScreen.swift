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
        VStack(alignment: .trailing) {
            TextField("Amount", text: $viewModel.amount)
                .textFieldStyle(.roundedBorder)
//            Picker
            ScrollView {
                Text("Exchange")
            }

        }
        .padding(16.0)
    }
}

struct CurrencyConverterScreen_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverterScreen(viewModel: .init())
    }
}
