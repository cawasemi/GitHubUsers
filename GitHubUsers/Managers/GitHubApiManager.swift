//
//  GitHubApiManager.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/09.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit
import APIKit
import KeychainAccess
import Himotoki

protocol GitHubRequest: Request {
    
}

extension GitHubRequest {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var headerFields: [String : String] {
        return ["Authorization": GitHubApiManager.shared.accessToken]
    }
}

extension GitHubRequest where Response: Himotoki.Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response.decodeValue(object)
    }
}

final class GitHubApiManager {
    static let shared = GitHubApiManager()
    
    private let accessTokenKey: String = "accessToken"
    
    private var keychain: Keychain
    
    private var _accessToken: String?

    /// アクセストークン
    var accessToken: String {
        set {
            self._accessToken = newValue
            do {
                try self.keychain.set(newValue, key: accessTokenKey)
            } catch let error {
                dump(error)
            }
        }
        get {
            if let token = self._accessToken {
                return String(format: "token %@", token)
            } else {
                return ""
            }
        }
    }
    
    /// アクセストークンの取得状態
    var hasAccessToken: Bool {
        if let accessToken = _accessToken {
            return !accessToken.isEmpty
        }
        return false
    }
    
    /// 現在ログインしているユーザーのログイン名
    var currentLogin: String? = nil

    private init() {
        self.keychain = Keychain(service: "com.cawasemi.GitHubUsers")
        do {
            self._accessToken = try self.keychain.get(accessTokenKey)
        } catch let error {
            dump(error)
        }
    }
    
    func clearAccessToken() {
        do {
            try keychain.remove(accessTokenKey)
            _accessToken = nil
            currentLogin = nil
        } catch let error {
            dump(error)
        }
    }
    
    // Mark: API Request

    struct RateLimitRequest: GitHubRequest {
        typealias Response = RateLimit
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/rate_limit"
        }
    }
    
    /// アクセストークン取得リクエスト
    ///
    /// Web ページを認証で取得したコードをもとにアクセストークンを取得する。
    struct AuthrizedRequest: GitHubRequest {
        typealias Response = GitHubAuthorized
        
        var code: String
        
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
    }

    /// すべてのユーザーを取得する。
    struct AllUsersRequest: GitHubRequest {
        typealias Response = [GitHubSearchUser]
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/users"
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
        let pageNo: Int
        
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
        
        // MARK: Request
        typealias Response = [GitHubUserRepository]
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            let encoded: String = login.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) ?? ""
            return String(format: "/users/%@/repos", encoded)
        }

        func response(from object: Any, urlResponse: HTTPURLResponse) throws -> [GitHubUserRepository] {
            return try decodeArray(object)
        }
    }
}

struct GitHubAuthorized: Himotoki.Decodable {
    let accessToken: String
    
    static func decode(_ e: Extractor) throws -> GitHubAuthorized {
        return try GitHubAuthorized(accessToken: e.value("access_token"))
    }
}

struct RateLimit: Himotoki.Decodable {
    let limit: Int
    let remaining: Int
    
    static func decode(_ e: Extractor) throws -> RateLimit {
        return try RateLimit(
            limit: e.value(["rate", "limit"]),
            remaining: e.value(["rate", "remaining"]))
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

struct SearchResponse<Item: Himotoki.Decodable>: Himotoki.Decodable {
    let items: [Item]
    let totalCount: Int
    
    static func decode(_ e: Extractor) throws -> SearchResponse {
        return try SearchResponse(
            items: e.array("items"),
            totalCount: e.value("total_count"))
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

extension GitHubRequest {
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard 200..<300 ~= urlResponse.statusCode else {
            throw GitHubError(object: object)
        }
        
        return object
    }
}
