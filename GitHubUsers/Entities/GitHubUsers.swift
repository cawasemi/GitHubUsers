//
//  GitHubUsers.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/03/17.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import Himotoki

struct GitHubUsers<User: Himotoki.Decodable>: Himotoki.Decodable {
    let incompleteResults: Bool
    let items: [User]
    let totalCount: Int64
    
    static func decode(_ e: Extractor) throws -> GitHubUsers {
        return try GitHubUsers(
            incompleteResults: e.value("incomplete_results"),
            items: e.array("items"),
            totalCount: e.value("total_count")
        )
    }
}
