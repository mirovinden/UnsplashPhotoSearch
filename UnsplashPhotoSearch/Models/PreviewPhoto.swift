//
//  PreviewPhoto.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 03.04.2023.
//

import Foundation

struct PreviewPhoto: Codable {
        let id: String
        let blurHash: String?
        let photoURL: PhotoURLS

        enum CodingKeys: String, CodingKey {
            case id
            case blurHash = "blur_hash"
            case photoURL = "urls"
        }
}
