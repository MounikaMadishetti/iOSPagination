//
//  SearchResponseItems.swift
//  Pagination
//
//  Created by Mounika Madishetti on 27/07/21.
//

import Foundation
// MARK: - SearchResponseItems
struct SearchResponseItems: Codable {
    let search: [Search]
    let totalResults, response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Search
struct Search: Codable, PhotoURLProtocol {
    let title, year, imdbID: String
    let type: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

protocol PhotoURLProtocol {}
extension PhotoURLProtocol where Self == Search {
    func getImagePath() -> URL? {
        let path = self.poster
        return URL(string: path)
    }
    
}

