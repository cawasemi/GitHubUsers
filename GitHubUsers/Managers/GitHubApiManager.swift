//
//  GitHubApiManager.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/09.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit
import KeychainAccess

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
}
