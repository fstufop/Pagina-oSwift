//
//  PaginationModel.swift
//  Pagination
//
//  Created by filipe.teodoro on 19/06/22.
//

import Foundation

struct PaginationModel: Decodable {
    let data: [Item]
    let pagination: Pagination
    
    struct Pagination: Decodable {
        let offset: Int
        let currentPage: Int
        let totalPages: Int
        let prevUrl: String?
        let nextUrl: String?

        enum CodingKeys: String, CodingKey {
            case offset
            case currentPage = "current_page"
            case totalPages = "total_pages"
            case prevUrl = "prev_url"
            case nextUrl = "next_url"
        }
    }
}

struct Item: Decodable {
    let title: String
}
