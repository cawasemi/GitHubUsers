//
//  GitHubApiUser.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/11.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import Foundation
import APIKit
import Himotoki

extension GitHubApiManager {
    /// 現在ログインしているユーザーの情報を取得する。
    struct GitHubCurrentUserRequest: GitHubRequest {
        // MARK: Request
        typealias Response = GitHubUser
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/user"
        }
    }
    
    /// 指定されたユーザーの情報を取得する。
    struct GitHubUserRequest: GitHubRequest {
        let login: String
        
        // MARK: Request
        typealias Response = GitHubUser
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            let encoded: String = login.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) ?? ""
            return String(format: "/users/%@", encoded)
        }
    }
    
    /// 指定されたユーザーのリポジトリー一覧を取得する。
    struct GitHubUserRepositoriesRequest: GitHubRequest {
        let login: String
        let pageNo: Int
        
        // MARK: Request
        typealias Response = [GitHubRepository]
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            let encoded: String = login.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) ?? ""
            return String(format: "/users/%@/repos", encoded)
        }
        
        var parameters: Any? {
            return ["page": pageNo]
        }
        
        func response(from object: Any, urlResponse: HTTPURLResponse) throws -> [GitHubRepository] {
            return try decodeArray(object)
        }
    }
}

class GitHubApiUser: GitHubApiRequest {
    var method: HTTPMethod {
        return .get
    }
}
