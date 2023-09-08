//
//  BaseViewModel.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 08/09/2023.
//

import Foundation

@MainActor
class BaseViewModel: ObservableObject {
    @Published var isRefreshing: Bool = false
    @Published var error: Error?
}
