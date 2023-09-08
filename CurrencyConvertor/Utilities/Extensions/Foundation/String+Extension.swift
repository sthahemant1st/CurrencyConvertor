//
//  String+Extension.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 08/09/2023.
//

import Foundation

extension String {
    var doubleValue: Double { Double(self) ?? 0 }
}
