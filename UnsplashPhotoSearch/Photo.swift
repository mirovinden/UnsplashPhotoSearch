//
//  Photo.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import Foundation



struct UnsplashPhoto: Codable {
    let identifier: String
    let description: String?
    let alternativeDescription: String?
    let blurHash: String
    let photoURL: PhotoURLS

    enum CodingKeys: String, CodingKey {
        case identifier  = "id"
        case description
        case alternativeDescription = "alt_description"
        case blurHash
        case photoURL = "urls"
    }
}

extension UnsplashPhoto: Hashable, Comparable {
    static func < (lhs: UnsplashPhoto, rhs: UnsplashPhoto) -> Bool {
        lhs.identifier > rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func == (lhs: UnsplashPhoto, rhs: UnsplashPhoto) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

struct PhotoURLS: Codable {
    let regular: URL
    let small: URL
    let full: URL
}


struct Photos: Codable {
    let photos: [UnsplashPhoto]
}
