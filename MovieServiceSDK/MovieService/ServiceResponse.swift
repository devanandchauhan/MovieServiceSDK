//
//  ErrorResponse.swift
//  
//
//  Created by Devanand Chauhan on 08/04/24.
//

import Foundation

public struct ServiceResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let success: Bool
}
