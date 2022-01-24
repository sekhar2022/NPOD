//
//  EndPoint.swift
//  NetworkLayer
//
//  Created by Chandra Sekhar Y on 23/01/22.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String? { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

