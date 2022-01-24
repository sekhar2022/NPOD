//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Chandra Sekhar Y on 23/01/22.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    static let APIKey = "bJj13v0uSepu7wbHCA8fs2tSW1iaL2EvijK7JrBn"
    let router = Router<NPODApi>()
    
    func getPicOfTheDay(for date: String, completion: @escaping (_ podData: NPODModelData?,_ error: String?)->()){
        router.request(.picOfTheDay(date: date)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(NPODModelData.self, from: responseData)
                        completion(apiResponse,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func downloadImage(from url: String, completion: @escaping (_ fileUrl: URL?,_ error: String?)->()) {
        router.downloadFile(.downloadImage(url: url)) { localFileUrl, error in
            guard let fileUrl = localFileUrl else {
                let errorMessage = error?.localizedDescription ?? "Please check your network connection."
                completion(nil, errorMessage)
                return
            }
            completion(fileUrl, nil)
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
