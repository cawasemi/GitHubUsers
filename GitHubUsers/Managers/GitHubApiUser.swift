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
import PromiseKit

class GitHubApiUser: GitHubApiRequest {
    typealias Response = GitHubUser

    var path: String {
        let encoded: String = login.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) ?? ""
        return String(format: "/users/%@", encoded)
    }
    
    private var login: String
    
    init() {
        self.login = ""
    }
    
    func getUser(_ login: String) -> Promise<GitHubUser> {
        self.login = login
        return Promise<GitHubUser> { (resolver) in
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
        // ---
    }
}
