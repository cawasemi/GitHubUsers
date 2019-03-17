//
//  GitHubSearchUser.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/03/17.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import Himotoki

struct GitHubSearchUser: Himotoki.Decodable {
    let id: Int64
    let login: String
    let iconUrl: String?
    let name: String?
    
    static func decode(_ e: Extractor) throws -> GitHubSearchUser {
        return try GitHubSearchUser(
            id: e.value("id"),
            login: e.value("login"),
            iconUrl: e.valueOptional("avatar_url"),
            name: e.valueOptional("name"))
    }
}
