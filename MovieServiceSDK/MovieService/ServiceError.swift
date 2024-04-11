//
//  File.swift
//  
//
//  Created by Devanand Chauhan on 08/04/24.
//

import Foundation

public enum ServiceError: Error, CustomNSError {

    case apiError
    case invalidEndpoint
    case invalidResponse
    case response(ServiceResponse)
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .response(let response): return response.statusMessage
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    public var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}
