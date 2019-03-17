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

/// 共通のパラメーターを定義する。
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

/// 共通のエラー処理
extension GitHubApiRequest {    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard 200..<300 ~= urlResponse.statusCode else {
            throw GitHubError(object: object)
        }
        return object
    }

    func printError(_ error: SessionTaskError) {
        switch error {
        case .responseError(let error as GitHubError):
            print(error.message) // Prints message from GitHub API
            
        case .connectionError(let error):
            print("Connection error: \(error)")
            
        default:
            print("System error :bow:")
        }
    }
}

extension GitHubApiRequest where Response: Himotoki.Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response.decodeValue(object)
    }
}

// https://developer.github.com/v3/#client-errors
struct GitHubError: Error {
    let message: String
    
    init(object: Any) {
        let dictionary = object as? [String: Any]
        message = dictionary?["message"] as? String ?? "Unknown error occurred"
    }
}
