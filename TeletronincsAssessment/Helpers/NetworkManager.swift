//
//  NetworkManager.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import Foundation
import Combine

class NetworkManager {

    static let shared = NetworkManager()
    
    // Base URL for the API
    private let baseURL = "https://api.unsplash.com/"
    
    // Function to fetch data from API
    func fetch<T: Codable>(_ type: T.Type, endpoint: String) -> AnyPublisher<[T], ErrorHandler> {
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            // Return a Fail publisher with an invalid URL error if URL is not valid
            return Fail(error: ErrorHandler.invalidUrl(error: "The URL is not valid!")).eraseToAnyPublisher()
        }
        
        // Create a data task publisher for the URL session
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                // Check if response status code is in the success range (200-299)
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    // Throw an API error with status code and message
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                    throw ErrorHandler.apiError(statusCode: statusCode, error: "Failed to fetch data. Status code: \(statusCode)")
                }
                return data   // Return data if successful
            }
            .decode(type: [T].self, decoder: JSONDecoder())  // Decode `JSON` data into array of type `T`
            .mapError { error in
                // Map decoding errors to `decodingError` in `ErrorHandler`
                if let decodingError = error as? DecodingError {
                    return ErrorHandler.decodingError(error: decodingError.localizedDescription)
                } else if let apiError = error as? ErrorHandler {
                    return apiError  // Pass through existing API errors
                } else {
                    return ErrorHandler.unknownError(error: "Unknown error occurred: \(error.localizedDescription)")
                }
            }
            .receive(on: DispatchQueue.main)  // Receive on main thread for UI updates
            .eraseToAnyPublisher()  // Type-erase publisher to hide implementation details
    }
}
