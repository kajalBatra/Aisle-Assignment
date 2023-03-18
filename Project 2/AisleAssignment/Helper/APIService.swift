//
//  APIService.swift
//  AisleAssignment
//
//  Created by Kajal Batra on 17/03/23.
//

import Foundation

let baseURL = "https://app.aisle.co/V1"

enum APIEndPoints : String {
    case phone_number   = "/users/phone_number_login"
    case verify_otp     = "/users/verify_otp"
    case notes_list     = "/users/test_profile_list"
}

enum HTTPMethod: String {
    case get
    case post
    
    var method: String { rawValue.uppercased() }
}

enum APICallError: Error {
    case invalidURL
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        }
    }
}

class APIService: NSObject {
    
    static let shared = APIService()
    
    typealias CompletionHandler<T : Codable> = ((_ response : T?,_ error : Error?) -> ())
    
    func request<T:Codable>(
        type        : T.Type,
        url         : APIEndPoints,
        httpMethod  : HTTPMethod = .get,
        param       : [String:Any]? = nil,
        headers     : [String: String]? = nil,
        completion  : @escaping CompletionHandler<T>) {
            
            let completeURL = baseURL + url.rawValue
            guard let url = URL(string: completeURL) else {
                completion(nil, APICallError.invalidURL)
                return
            }
            
            Loader.show()
            
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.method
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            headers?.forEach({
                request.setValue($0.value, forHTTPHeaderField: $0.key)
            })
            
            if let params = param {
                let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                request.httpBody = jsonData
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                Loader.hide()
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                
                guard let data = data else {return}
                
                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    debugPrint(model)
                    completion(model, error)
                } catch let exception {
                    completion(nil, exception)
                    debugPrint("Parsing error: ", exception.localizedDescription)
                }
            }.resume()
        }
}
