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
    let photoURL: PhotoURLS



    enum CodingKeys: String, CodingKey {
        case identifier  = "id"
        case description
        case alternativeDescription = "alt_description"
        case photoURLS = "urls"

    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(description, forKey: .description)
        try container.encode(photoURL, forKey: .photoURLS)
        try container.encode(alternativeDescription, forKey: .alternativeDescription)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .identifier)
        let descr = try container.decodeIfPresent(String.self, forKey: .description)
        let photoURLs = try container.decode(PhotoURLS.self, forKey: .photoURLS)
        let alternativeDescription = try container.decodeIfPresent(String.self, forKey: .alternativeDescription)

        self.description = descr
        self.alternativeDescription = alternativeDescription
        self.identifier = id
        self.photoURL = photoURLs
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
    let regular: String
    let small: String
    let full: String
}


struct Photos: Codable {
    let photos: [UnsplashPhoto]
}
