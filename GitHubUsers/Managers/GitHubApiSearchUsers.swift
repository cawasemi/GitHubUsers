//
//  GitHubApiSearchUsers.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/11.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import Foundation
import APIKit
import Himotoki

extension GitHubApiManager {
    /// すべてのユーザーを取得する。
    struct AllUsersRequest: GitHubRequest {
        typealias Response = [GitHubSearchUser]
        
        let since: Int64
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/users"
        }
        
        var parameters: Any? {
            return ["since": since]
        }
        
        func response(from object: Any, urlResponse: HTTPURLResponse) throws -> [GitHubSearchUser] {
            return try decodeArray(object)
        }
    }
    
    
    /// ユーザー検索リクエスト
    ///
    /// 指定された条件に一致するユーザーを検索する。
    struct SearchUsersRequest: GitHubRequest {
        let query: String
        let pageNo: Int64
        
        // MARK: Request
        typealias Response = SearchResponse<GitHubSearchUser>
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/search/users"
        }
        
        var parameters: Any? {
            return ["q": query, "page": pageNo]
        }
    }
}

struct GitHubSearchUser: Himotoki.Decodable {
    let id: Int64
    let login: String
    let iconUrl: String?
    
    static func decode(_ e: Extractor) throws -> GitHubSearchUser {
        return try GitHubSearchUser(
            id: e.value("id"),
            login: e.value("login"),
            iconUrl: e.value("avatar_url"))
    }
}
