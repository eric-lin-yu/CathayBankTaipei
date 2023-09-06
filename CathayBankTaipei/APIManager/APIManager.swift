//
//  APIManager.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2023/9/6.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

enum APIResult {
    case success(data: Data)
    case failure(error: Error)
}

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func request(endpoint: String, method: HttpMethod, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(APIError.networkError))
            }
        }.resume()
    }
}
