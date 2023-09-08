//
//  Double+Extension.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 08/09/2023.
//

import Foundation
extension Double {
    func roundedString(_ places: Int = 3) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = places
        return numberFormatter.string(from: NSNumber(value: self)) ?? "--"
    }
    
    var intValue: Int { Int(self) }
}
