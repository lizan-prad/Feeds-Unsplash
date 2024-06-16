//
//  ErrorHandler.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import Foundation

// Error handlers for API responses
enum ErrorHandler: Error {
    case invalidUrl(error: String)
    case decodingError(error: String)
    case apiError(statusCode: Int, error: String)
    case unknownError(error: String)
}
