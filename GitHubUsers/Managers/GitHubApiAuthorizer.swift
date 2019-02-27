//
//  GitHubApiAuthorizer.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/23.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import APIKit
import Himotoki

class GitHubApiAuthorizer: GitHubApiRequest {
    typealias Response = GitHubAuthorized
    
    var method: HTTPMethod {
        return .post
    }
    
    var baseURL: URL {
        return URL(string: "https://github.com")!
    }
    
    var path: String {
        return "/login/oauth/access_token"
    }
    
    var headerFields: [String : String] {
        return ["Accept": "application/json"]
    }
    
    var parameters: Any? {
        return ["client_id": "c82b3a07dbc4915a92d1", "client_secret": "c2477409c6951cf55310a096ae2b3dc9bdfd811f", "code": code]
    }

    var code: String
    
    init(_ code: String) {
        self.code = code
    }
}
