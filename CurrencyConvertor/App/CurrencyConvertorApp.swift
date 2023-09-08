//
//  CurrencyConvertorApp.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 06/09/2023.
//

import SwiftUI

@main
struct CurrencyConvertorApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CurrencyConverterScreen(viewModel: .init())
            }
        }
    }
}
