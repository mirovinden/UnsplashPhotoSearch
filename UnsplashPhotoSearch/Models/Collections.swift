//
//  CollectionsSeachData.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 27.03.2023.
//

import Foundation


struct Collection: Codable {
    let id: String
    let title: String
    let totalPhotos: Int
    let photosURL: URL
    let photoPreviews: [PreviewPhoto]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)

        let new = try decoder.container(keyedBy: NewKey.self)
        let links = try new.decode(Links.self, forKey: .links)
        let previewPhotos = try new.decode([PreviewPhoto].self, forKey: .preview)
        let totalPhotos = try new.decode(Int.self, forKey: .totalPhotos)
        self.totalPhotos = totalPhotos
        self.photosURL = links.photos
        self.photoPreviews = previewPhotos
    }

    enum NewKey: String, CodingKey {
        case links
        case preview = "preview_photos"
        case totalPhotos = "total_photos"
    }

    struct Links: Codable {
        let photos: URL
    }
}

extension Collection: Hashable, Comparable {
    static func == (lhs: Collection, rhs: Collection) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: Collection, rhs: Collection) -> Bool {
        lhs.id > rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}




