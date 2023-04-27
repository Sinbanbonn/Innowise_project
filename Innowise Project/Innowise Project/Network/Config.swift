//
//  Config.swift
//  Innowise Project
//
//  Created by Андрей Логвинов on 4/27/23.
//

import Foundation
import Alamofire

class NetworkConfiguration {
    private let apiUrl: String
    private let header: [String : String]
    private let body: [String : String]
    
    init(scheme: String, host: String, path: String , header: [String: String] = [:] , body: [String:String] = [:]) {
        self.body = body
        self.header = header
        apiUrl = scheme + host + path
    }
    
    
    
    func getBaseUrl()-> String {
        return apiUrl
    }
    
    func getHeaders()->HTTPHeaders{
        return HTTPHeaders(header)
    }
    
    func getParametrs()->[String : String]{
        return body
    }
    
    
       
    
    
}
