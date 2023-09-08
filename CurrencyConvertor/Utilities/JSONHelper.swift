//
//  JSONHelper.swift
//  DemoSwiftUI
//
//  Created by Hemant Shrestha on 05/09/2023.
//

import Foundation

struct JSONHelper {
    static func convert<T: Decodable>(name: String, type: T.Type) throws -> T {
        let url = Bundle.main.url(forResource: name, withExtension: "json")
        guard let url else { throw JSONHelpError.fileNotFound }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let products = try decoder.decode(T.self, from: data)
        return products
    }
    
    enum JSONHelpError: Error {
        case fileNotFound
    }
}
