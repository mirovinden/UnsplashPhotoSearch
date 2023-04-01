//
//  PhotoDetailController.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.04.2023.
//

import UIKit
import Kingfisher

@MainActor
class PhotoDetailController {
    let photoId: String!
    var photoDataTask: Task<Void, Never>? = nil

    init(photoId: String) {
        self.photoId = photoId
    }

    func fetchPhotoData() async throws ->  Photo {
        let photoData = try await PhotoDataRequest().fetchPhotoData(photoId: photoId)

        return photoData
    }
}
