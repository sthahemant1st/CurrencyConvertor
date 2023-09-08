//
//  PersistanceHelper.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 08/09/2023.
//

import Foundation

struct PersistenceHelper {
    private static let rateResponseFileName = "rateResponse"

    static func saveRateResponse(_ rateResponse: RateResponse) throws {
        let dataToSave = try JSONEncoder().encode(rateResponse)
        let path = getDocumentsDirectory()
            .appendingPathComponent(rateResponseFileName)
        
        try dataToSave.write(to: path)
    }
    
    static func getRateResponse() -> RateResponse? {
        let path = getDocumentsDirectory()
            .appendingPathComponent(rateResponseFileName)
        
        let savedData = try? Data(contentsOf: path)
        guard let savedData else { return nil }
        
        return try? savedData.decode(RateResponse.self)
    }
    
    static private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
