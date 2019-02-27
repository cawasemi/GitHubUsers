//
//  GitHubRepository.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/23.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import Himotoki

struct GitHubRepository: Himotoki.Decodable {
    let id: Int64
    let name: String?
    let htmlUrl: String
    let description: String?
    let isFork: Bool
    let language: String?
    let stargazers: Int64
    
    static func decode(_ e: Extractor) throws -> GitHubRepository {
        return try GitHubRepository(
            id: e.value("id"),
            name: e.valueOptional("name"),
            htmlUrl: e.value("html_url"),
            description: e.valueOptional("description"),
            isFork: e.value("fork"),
            language: e.valueOptional("language"),
            stargazers: e.value("stargazers_count"))
    }
}
