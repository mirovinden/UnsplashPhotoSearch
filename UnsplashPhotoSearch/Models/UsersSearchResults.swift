//
//  UsersSearchResults.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 30.03.2023.
//

import Foundation

struct UsersSearchResults: Codable {
    let total: Int
    let total_pages: Int
    let results: [User]
}
