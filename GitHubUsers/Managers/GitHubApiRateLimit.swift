//
//  GitHubApiRateLimit.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/03/17.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import APIKit
import Himotoki
import PromiseKit

struct GitHubRateLimit: Himotoki.Decodable {
    let limit: Int
    let remaining: Int
    
    static func decode(_ e: Extractor) throws -> GitHubRateLimit {
        return try GitHubRateLimit(
            limit: e.value(["rate", "limit"]),
            remaining: e.value(["rate", "remaining"]))
    }
}

class GitHubApiRateLimit: GitHubApiRequest {
    typealias Response = GitHubRateLimit

    var path: String {
        return "/rate_limit"
    }
    
    func getRateLimit() -> Promise<Response> {
        return Promise { (resolver) in
            APIKit.Session.send(self) { [weak self] (result) in
                switch result {
                case .success(let response):
                    resolver.fulfill(response)
                    break
                case .failure(let error):
                    self?.printError(error)
                    resolver.reject(error)
                    break
                }
            }
        }
        // --
    }
}
