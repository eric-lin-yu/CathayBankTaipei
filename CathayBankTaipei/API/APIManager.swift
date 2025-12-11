//
//  APIManager.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2023/9/6.
//

import Foundation

// MARK: - Error Types
enum APIError: Error {
    case invalidURL
    case networkError
    case decodingFailed(Error)
    case emptyData
}

// MARK: - Basic Wrapper
struct BasicModel<R: Decodable>: Decodable {
    let response: R?
    let returnStatus: String?
    let returnMessage: String?
}

// MARK: - API Manager
class APIManager {
    static let shared = APIManager()
    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    /// Generic GET
    func sendGet<T: Decodable>(endpoint: String,
                               responseType: T.Type,
                               completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            DispatchQueue.main.async { completion(.failure(APIError.invalidURL)) }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        printRequest(endpoint: endpoint, method: "GET", body: nil)


        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(APIError.emptyData)) }
                return
            }
            
            self.printResponse(endpoint: endpoint, method: "GET", responseData: data)

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(APIError.decodingFailed(error))) }
            }
        }.resume()
    }

    /// Generic POST
    func sendPost<Body: Encodable, T: Decodable>(endpoint: String,
                                                 body: Body,
                                                 responseType: T.Type,
                                                 completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            DispatchQueue.main.async { completion(.failure(APIError.invalidURL)) }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        var requestBodyData: Data?

        do {
            requestBodyData = try JSONEncoder().encode(body)
            request.httpBody = requestBodyData
        } catch {
            DispatchQueue.main.async { completion(.failure(APIError.decodingFailed(error))) }
            return
        }
        
        self.printRequest(endpoint: endpoint, method: "POST", body: requestBodyData)

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(APIError.emptyData)) }
                return
            }
            
            self.printResponse(endpoint: endpoint, method: "POST", responseData: data)

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(APIError.decodingFailed(error))) }
            }
        }.resume()
    }
}

// MARK: - Logging Helpers
extension APIManager {
    /// 列印 API Request 資訊
    private func printRequest(endpoint: String, method: String, body: Data?) {
        print("\n\n✅ ==================== API Request ====================")
        print("➡️ [\(method)] Endpoint: \(endpoint)")
        if let body = body, !body.isEmpty {
            print("Request Body:\n\(body.prettyJsonString)")
        } else {
            print("Request Body: None (GET)")
        }
        print("======================================================\n")
    }
    
    /// 列印 API Response 資訊
    private func printResponse(endpoint: String, method: String, responseData: Data) {
        print("\n\n✅ ==================== API Response ===================")
        print("⬅️ [\(method)] Endpoint: \(endpoint)")
        print("Response Body:\n\(responseData.prettyJsonString)")
        print("======================================================\n")
    }
}
