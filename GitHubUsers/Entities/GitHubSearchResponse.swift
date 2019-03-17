//
//  GitHubSearchResponse.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/03/17.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import Himotoki

struct GitHubSearchResponse<Item: Himotoki.Decodable>: Himotoki.Decodable {
    let items: [Item]
    let incompleteResults: Bool
    let totalCount: Int64

    static func decode(_ e: Extractor) throws -> GitHubSearchResponse {
        return try GitHubSearchResponse(
            items: e.array("items"),
            incompleteResults: e.value("incomplete_results"),
            totalCount: e.value("total_count"))
    }
}
