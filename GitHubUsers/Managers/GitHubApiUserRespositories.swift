//
//  GitHubApiUserRespositories.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/03/17.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import APIKit
import Himotoki
import PromiseKit

/// ユーザーのリポジトリー情報を取得する。
class GitHubApiUserRepositories: GitHubApiRequest {
    typealias Response = [GitHubRepository]

    var path: String {
        let encoded: String = login.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) ?? ""
        return String(format: "/users/%@/repos", encoded)
    }
    
    var parameters: Any? {
        return ["page": pageNo]
    }
    
    private var login: String
    private var pageNo: Int
    
    init(_ login: String) {
        self.login = login
        self.pageNo = 0
    }
    
    func next(_ pageNo: Int) -> Promise<Response> {
        self.pageNo = pageNo
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
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeArray(object)
    }
}
