//
//  NetworkClient.swift
//  Innowise Project
//
//  Created by Андрей Логвинов on 4/27/23.
//

import Foundation
import Alamofire


class NetworkClient {
    let config  = NetworkConfiguration(scheme: "https://", host: "api.bitbucket.org", path: "/2.0/repositories?fields=values.name,values.owner,values.description")
    
    lazy var session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300
        return Session(configuration: configuration)
    }()
    
    func doRequest(method: HTTPMethod = .get , parametrs: [String : String] = [:], headers: [String: String] = [:]){
        
        session.request(config.getBaseUrl() , method: method, headers: config.getHeaders())
            .response{ response in
                switch response.result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    var errText: String
                    if let urlError = error.underlyingError as? URLError {
                       errText = ErrorHandler.URLErrorHandler(urlError: urlError)
                    } else if let httpError = error as? HTTPURLResponse {
                        errText = ErrorHandler.httpErrorHandler(httpError: httpError)
                    } else {
                        errText = "Undefined error!"
                    }
                    
                    print(errText)
                    
                }
                
            }
        
    }
    
    
    
}
