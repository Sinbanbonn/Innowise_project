//
//  ErrorHandler.swift
//  Innowise Project
//
//  Created by Андрей Логвинов on 4/27/23.
//

import Foundation

class ErrorHandler{
    
    static func URLErrorHandler(urlError : URLError)-> String{
        var errText: String
        switch urlError.code{
        case .notConnectedToInternet:
            print("No internet connection")
            errText = "No internet connection"
        case .timedOut:
            errText = "Timeout expired"
        case .unsupportedURL:
            errText = "Unknown url"
            
        default:
            errText = "Error wirh code \(urlError.localizedDescription)"
        
        }
        
        return errText
    }
    
    static func httpErrorHandler(httpError: HTTPURLResponse)-> String{
        var errText: String
        switch httpError.statusCode{
        case 404:
            errText = "404... Not found"
        case 400:
            errText = "400... Bad request"
        case 401:
            errText = "401... Invalid credentials"
        case 403:
            errText = "403... Forbidden"
        case 500:
            errText = "500... Internal Server Error"
        default:
            errText = "Error with code \(httpError.statusCode)"
        }
        
        return errText
    }
}
