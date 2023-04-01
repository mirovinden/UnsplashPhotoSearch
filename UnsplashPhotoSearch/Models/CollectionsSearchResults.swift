//
//  CollectionsSearch.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 28.03.2023.
//

import Foundation

struct CollectionsSearchResults: Codable {
    let total: Int
    let total_pages: Int
    let results: [Collection]
}
