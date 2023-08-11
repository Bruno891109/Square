//
//  RequestManager.swift
//  Square
//
//  Created by MacDev1 on 2/8/23.
//

import Foundation

let SERVER_URL = "https://s3.amazonaws.com"
let PLAYGROUND = "sq-mobile-interview"

class RequestManager {
    enum REQUEST_ACTION:String {
        case ACTION_FETCH = "employees"
        case ACTION_FETCH_EMPTY = "employees_empty"
        case ACTION_FETCH_FAIL = "employees_malformed"
        
        subscript() -> String {
            get {
                switch self{
                case .ACTION_FETCH:
                    return "Get Emplyoees from Server"
                case .ACTION_FETCH_EMPTY:
                    return "Get Emplyoees(empty) from Server"
                case .ACTION_FETCH_FAIL:
                    return "Get Emplyoees() from Server"
                }
            }
        }
    }
    enum REQUEST_ERROR: Error {
        case invalidURL
        case invalidRequest(onAction: REQUEST_ACTION, errorMsg: String)
        case invalidResponse(onAction: REQUEST_ACTION)
    }
    
    func squareEndPoint(actionName action: String) -> URL? {
        return URL(string: "\(SERVER_URL)/\(PLAYGROUND)/\(action).json")
    }
    
    func fetchUsers(request: REQUEST_ACTION, completion:@escaping (Employees) -> (), failure:@escaping (REQUEST_ERROR) -> ()){
        guard let end_point = squareEndPoint(actionName: request.rawValue) else {
            DispatchQueue.main.async {
                failure(REQUEST_ERROR.invalidURL)
            }
            return
        }
        URLSession.shared.dataTask(with: end_point) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    failure(REQUEST_ERROR.invalidRequest(onAction: REQUEST_ACTION.ACTION_FETCH, errorMsg: error!.localizedDescription))
                }
                return
            }
            
            do {
                let dictionary = try JSONDecoder().decode([String:Employees].self, from: data!)
                if let users = dictionary["employees"] {
                    DispatchQueue.main.async {
                        completion(users)
                    }
                }
            } catch{
                DispatchQueue.main.async {
                    failure(REQUEST_ERROR.invalidResponse(onAction: REQUEST_ACTION.ACTION_FETCH))
                }
            }
        }
        .resume()
    }
}

