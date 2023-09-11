//
//  JSONHelper.swift
//  DemoSwiftUI
//
//  Created by Hemant Shrestha on 05/09/2023.
//

import Foundation

struct JSONHelper {
    static func convert<T: Decodable>(
        name: String,
        type: T.Type,
        in bundle: Bundle = .main
    ) throws -> T {
        let url = bundle.url(forResource: name, withExtension: "json")
        guard let url else {
            throw JSONHelperError.fileNotFound(fileName: name)
        } 
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let products = try decoder.decode(T.self, from: data)
            return products
        } catch {
            throw JSONHelperError.decodingError(errorDesc: error.localizedDescription)
        }
        
    }
}

enum JSONHelperError: LocalizedError, Equatable {
    case fileNotFound(fileName: String)
    case decodingError(errorDesc: String)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let fileName):
            return "File not found with fileName: \(fileName)"
        case .decodingError(let errorDes):
            return "Decoding Error: \(errorDes)"
        }
    }
}
