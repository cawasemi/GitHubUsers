//
//  GitHubApiRequest.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/23.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import Foundation
import APIKit
import Himotoki

protocol GitHubApiRequest: APIKit.Request {
    
}

extension GitHubApiRequest {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headerFields: [String : String] {
        return ["Authorization": GitHubApiManager.shared.accessToken]
    }
}

extension GitHubApiRequest where Response: Himotoki.Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response.decodeValue(object)
    }
}
