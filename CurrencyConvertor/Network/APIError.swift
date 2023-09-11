//
//  APIError.swift
//  DemoSwiftUI
//
//  Created by Hemant Shrestha on 05/09/2023.
//

import Foundation

enum APIError: LocalizedError {
    case accessRestricted(String?)
    case decodingError(Error)
    case encodingError(Error?)
    case invalidRequest(String)
    case internalServerError
    case notFound(String?) // bad request
    case transportError // noInternet
    case missingAppId(String?) // missingAppId
    case unknown
    case other(String)
    case validationError(Error)

    var errorDescription: String? {
        switch self {
        case .accessRestricted(let description):
            return "Access Restricted: \(description ?? "-")"
        case .decodingError(let error):
            return "Decoding Error \(error.localizedDescription)"
        case .encodingError(let error):
            return "Encoding Error \(error?.localizedDescription ?? "")"
        case .invalidRequest(let errorMessage):
            return "Invalid Request \(errorMessage)"
        case .internalServerError:
            return "Internal Server Error"
        case .notFound(let message):
            return message
        case .transportError:
            return "No internet connection"
        case .missingAppId(let description):
            return "Unauthorized: \(description ?? "-")"
        case .unknown:
            return "Unknown Error: "
        case .other(let description):
            return description
        case .validationError:
            return "Validation Error"
        }
    }
}
