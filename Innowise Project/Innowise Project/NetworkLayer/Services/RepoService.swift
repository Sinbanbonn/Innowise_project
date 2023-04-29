//
//  RepoService.swift
//  Innowise Project
//
//  Created by Андрей Логвинов on 4/29/23.
//

import Foundation

protocol RepoServiciable {
    func getGitData() async -> Result<[GitRep], RequestError>
    func GetBibBucketData() async -> Result<BucketData, RequestError>
}

struct RepoService: HTTPClient, RepoServiciable {
    
    func getGitData() async -> Result<[GitRep], RequestError> {
        print("gegGitData was called")
        return await sendRequest(endpoint: ReposEndpoint.git, responseModel: [GitRep].self)
    }
    
    func GetBibBucketData() async -> Result<BucketData, RequestError> {
        print("GetBibBucketData was called ")
        return await sendRequest(endpoint: ReposEndpoint.bitBucket, responseModel: BucketData.self)
    }
}
