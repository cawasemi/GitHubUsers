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
import PromiseKit

typealias GitHubUsers = GitHubSearchResponse<GitHubSearchUser>

class GitHubApiSearchUsers: GitHubApiRequest {
    typealias Response = GitHubUsers
    
    var path: String {
        return "/search/users"
    }
    
    var parameters: Any? {
        return ["q": query, "page": pageIndex]
    }
    
    private var pageIndex: Int64
    private var query: String
    
    init() {
        self.pageIndex = 0
        self.query = ""
    }
    
    func next(_ pageIndex: Int64, query: String) -> Promise<Response> {
        self.pageIndex = pageIndex
        self.query = query
        return Promise<Response> { resolver in
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
    }
}

class GitHubApiAllhUsers: GitHubApiRequest {
    typealias Response = [GitHubSearchUser]
    
    var path: String {
        return "/users"
    }
    
    var parameters: Any? {
        return ["since": pageIndex]
    }
    
    private var pageIndex: Int64
    
    init() {
        self.pageIndex = 0
    }
    
    func next(_ pageIndex: Int64) -> Promise<GitHubUsers> {
        self.pageIndex = pageIndex
        return Promise<GitHubUsers> { resolver in
            APIKit.Session.send(self) { [weak self] (result) in
                switch result {
                case .success(let response):
                    let users = GitHubUsers( items: response, incompleteResults: false, totalCount: -1)
                    resolver.fulfill(users)
                    break
                case .failure(let error):
                    self?.printError(error)
                    resolver.reject(error)
                    break
                }
            }
        }
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeArray(object)
    }
}
