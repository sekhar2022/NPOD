//
//  MovieEndPoint.swift
//  NetworkLayer
//
//  Created by Chandra Sekhar Y on 23/01/22.
//

import Foundation

public enum NPODApi {
    case picOfTheDay(date: String)
    case downloadImage(url: String)
}

extension NPODApi: EndPointType {
    
    var baseUrlString : String {
        switch self {
        case .picOfTheDay:
            return "https://api.nasa.gov/planetary"
        case .downloadImage(let url):
            return url
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: baseUrlString) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String? {
        switch self {
        case .picOfTheDay(_):
            return "/apod"
        case .downloadImage(_):
            return nil
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .picOfTheDay(let date):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["api_key": NetworkManager.APIKey,
                                                      "date":date])
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}


