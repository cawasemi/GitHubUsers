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
        typealias Response = [GitHubUserRepository]
        
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
        
        func response(from object: Any, urlResponse: HTTPURLResponse) throws -> [GitHubUserRepository] {
            return try decodeArray(object)
        }
    }
}

struct GitHubUser: Himotoki.Decodable {
    let id: Int64
    let login: String
    let iconUrl: String?
    let name: String?
    let followers: Int64
    let following: Int64
    
    static func decode(_ e: Extractor) throws -> GitHubUser {
        return try GitHubUser(
            id: e.value("id"),
            login: e.value("login"),
            iconUrl: e.valueOptional("avatar_url"),
            name: e.valueOptional("name"),
            followers: e.value("followers"),
            following: e.value("following"))
    }
}

struct GitHubUserRepository: Himotoki.Decodable {
    let id: Int64
    let name: String?
    let htmlUrl: String
    let description: String?
    let isFork: Bool
    let language: String?
    let stargazers: Int64
    
    static func decode(_ e: Extractor) throws -> GitHubUserRepository {
        return try GitHubUserRepository(
            id: e.value("id"),
            name: e.valueOptional("name"),
            htmlUrl: e.value("html_url"),
            description: e.valueOptional("description"),
            isFork: e.value("fork"),
            language: e.valueOptional("language"),
            stargazers: e.value("stargazers_count"))
    }
}
