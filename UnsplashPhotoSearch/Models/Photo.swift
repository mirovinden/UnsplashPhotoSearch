//
//  Photo.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import Foundation

struct Photo: Codable {
    let identifier: String
    let description: String?
    let alternativeDescription: String?
    let blurHash: String
    let photoURL: PhotoURLS
    let user: User?
    let likes: Int?
    let location: Location?

    enum CodingKeys: String, CodingKey {
        case identifier  = "id"
        case description
        case alternativeDescription = "alt_description"
        case blurHash = "blur_hash"
        case photoURL = "urls"
        case user
        case likes
        case location
    }
}

//extension Photo: Hashable, Comparable {
//    static func < (lhs: Photo, rhs: Photo) -> Bool {
//        lhs.identifier > rhs.identifier
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(identifier)
//    }
//    static func == (lhs: Photo, rhs: Photo) -> Bool {
//        return lhs.identifier == rhs.identifier
//    }
//}

struct PhotoURLS: Codable {
    let regular: URL
    let small: URL
    let full: URL
}

struct Location:Codable {
    let name: String?
    let city: String?
    let country: String?
    let coordinate: Coordinate?
}
struct Coordinate: Codable {
    let latitude: String?
    let longitude: String?
}
