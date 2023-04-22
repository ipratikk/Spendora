//
//  APIManager.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 21/04/23.
//
import Foundation

public class APIManager<T: Decodable> {
    public enum APIError: Error {
        case decodingError
        case serverError
        case unknownError
    }

    public func request(endpoint: String, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.unknownError))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(.serverError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError))
                return
            }

            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }

        task.resume()
    }

    public init(fileName: String) throws {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw APIError.unknownError
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            self.data = decodedResponse
        } catch {
            throw APIError.decodingError
        }
    }

    public var data: T?
}
