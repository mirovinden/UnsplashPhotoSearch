//
//  PhotoSearch.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import Foundation


struct PhotoSearch: Codable {
    let total: Int
    let total_pages: Int
    let results: [UnsplashPhoto]
}
