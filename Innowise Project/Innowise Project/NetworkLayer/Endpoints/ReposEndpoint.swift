//
//  ReposEndpoint.swift
//  Innowise Project
//
//  Created by Андрей Логвинов on 4/29/23.
//

import Foundation

enum ReposEndpoint {
    case git
    case bitBucket
}


extension ReposEndpoint: Endpoint {
    var host: String {
        switch self {
        case .git:
            return "api.github.com"
        case .bitBucket:
            return "api.bitbucket.org"
        }
    }
    
    var path: String {
        switch self {
        case .git:
            return "/repositories"
        case .bitBucket:
            return "/2.0/repositories?fields=values.name,values.owner,values.description"
        }
    }

    var method: RequestMethod {
        switch self {
        case .git, .bitBucket:
            return .get
        }
    }

    var header: [String: String]? {
        
        switch self {
        case .git, .bitBucket:
            return nil
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .git, .bitBucket:
            return nil
        }
    }
}
