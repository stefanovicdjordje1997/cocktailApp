//
//  NetworkErrors.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/4/23.
//

import Foundation

// MARK: - NetworkErrors

enum NetworkErrors: LocalizedError {
    case invalidUrlError
    case noDataError
    
    var localizedDescription: String {
        switch self {
            
        case .invalidUrlError:
            return "Url provided is not valid."
            
        case .noDataError:
            return "Server didn't return data."
        }
    }
}

// MARK: - DrinkErrors

enum DrinkErrors: LocalizedError {
    case apiError
    case decodingError
    
    var localizedDescription: String {
        switch self {
            
        case .apiError:
            return "Error fetching data from api."
            
        case .decodingError:
            return "Error decoding model data."
        }
    }
}
