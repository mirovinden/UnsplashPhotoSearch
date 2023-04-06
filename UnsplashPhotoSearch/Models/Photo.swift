//
//  Photo.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit

extension UIImage {
   static func blurHash(from photo: Photo) -> UIImage {
        let blurHash = photo.blurHash
        let blurHashHeight = photo.height / 100
        let blurHashWidth = photo.width / 100
        let blurHashSize = CGSize(width: blurHashWidth, height: blurHashHeight)

        let image = UIImage(blurHash: blurHash ?? "", size: blurHashSize)!

        return image
    }
}

struct Photo: Codable {
    let id: String
    let description: String?
    let alternativeDescription: String?
    let blurHash: String?
    let height: Int
    let width: Int
    let photoURL: PhotoURLS
    let user: User?
    let likes: Int?
    let location: Location?

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case alternativeDescription = "alt_description"
        case blurHash = "blur_hash"
        case height
        case width
        case photoURL = "urls"
        case user
        case likes
        case location
    }
    
}


struct PhotoURLS: Codable {
    let regular: URL
    let small: URL
    let full: URL
    let thumb: URL
}

struct Location:Codable {
    let name: String?
    let city: String?
    let country: String?
    let position: Coordinate
}
struct Coordinate: Codable {
    let latitude: Double?
    let longitude: Double?
}


