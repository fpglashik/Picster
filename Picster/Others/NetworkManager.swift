//
//  NetworkManager.swift
//  Picster
//
//  Created by mac 2019 on 1/25/24.
//

import Foundation

enum NetworkError: String, Error, LocalizedError{
    case invalidUrl = "Invalid Url"
    case failedToFetchData = "Failed To Fetch Data"
    
    var errorDescription: String?{
        switch self{
        case .invalidUrl: return NSLocalizedString("Provided URL is invalid", comment: "")
        case .failedToFetchData: return NSLocalizedString("Couldn't fetch data from provided url", comment: "")
        }
    }
}

enum NetworkManager{

    static func fetchData(from urlString: String?) async throws -> Data {
        guard let urlString,
              let urlQueryAllowedString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
              let url = URL(string: urlQueryAllowedString) else {
            throw NetworkError.invalidUrl
        }
        
        let response = try await URLSession.shared.data(for:  URLRequest(url: url))
        return response.0
        
    }
}
