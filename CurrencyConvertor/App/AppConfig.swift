//
//  AppConfig.swift
//  DemoSwiftUI
//
//  Created by Hemant Shrestha on 06/09/2023.
//

import Foundation

struct AppConfig {
    enum Keys {
        static let baseURL = "BASE_URL"
        static let appID = "APP_ID"
    }

    static var baseURL: String {
        guard let baseURLProperty = Bundle.main.object(forInfoDictionaryKey: Keys.baseURL) as? String else {
            return "www.example.com"
        }
        return baseURLProperty
    }
    static var appID: String {
        guard let baseURLProperty = Bundle.main.object(forInfoDictionaryKey: Keys.appID) as? String else {
            return "appID"
        }
        return baseURLProperty
    }
}
