//
//  NetworkCaller.swift
//  DemoSwiftUI
//
//  Created by Hemant Shrestha on 05/09/2023.
//

import Foundation

class NetworkCaller {
    private var session: URLSession

    static let shared: NetworkCaller = .init()

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: configuration)
    }

    func request<T>(
        withEndPoint endPoint: EndpointProtocol,
        returnType: T.Type
    ) async throws -> T where T: Decodable {
        guard endPoint.httpMethod == .get else {
            return try await upload(withEndPoint: endPoint, returnType: returnType)
        }

        do {
            NetworkLogHelper.log(request: endPoint.request, body: nil)
            let (data, response) = try await session.data(for: endPoint.request)
            return try await handle(data: data, response: response, returnType: returnType)
        } catch {
            throw APIError.transportError
        }
    }
}

// MARK: - private functions
extension NetworkCaller {
    /// used for except POST request
    private func upload<T>(
        withEndPoint endPoint: EndpointProtocol,
        returnType: T.Type
    ) async throws -> T where T: Decodable {

        guard let body = endPoint.body else {
            throw APIError.invalidRequest("Body Empty")
        }
        do {
            let jsonEncoder = JSONEncoder()
            let requestData = try jsonEncoder.encode(body)
            NetworkLogHelper.log(request: endPoint.request, body: requestData)
            let (data, response) = try await session.upload(for: endPoint.request, from: requestData)

            return try await handle(data: data, response: response, returnType: returnType)
        } catch EncodingError.invalidValue(_, let context) {
            throw APIError.encodingError(context.underlyingError)
        } catch {
            throw APIError.transportError
        }

    }

    /// parses data if success else throws error
    private func handle<T>(
        data: Data,
        response: URLResponse,
        returnType: T.Type
    )  async throws -> T where T: Decodable {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }
        NetworkLogHelper.log(data: data, response: httpResponse, error: nil)

        if httpResponse.statusCode == 200 {
            do {
                let apiResponse = try data.decode(T.self)
                return apiResponse
            } catch {
                throw APIError.decodingError(error)
            }
        } else {

            switch httpResponse.statusCode {
            case 400:
                throw APIError.notFound("Some message form server")
            case 401:
                throw APIError.sessionExpired
            case 500:
                throw APIError.internalServerError
            default:
                throw APIError.unknown
            }
        }
    }
}
