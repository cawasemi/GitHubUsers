//
//  GitHubUser.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/23.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import Himotoki

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
