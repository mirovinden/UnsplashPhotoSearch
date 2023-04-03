//
//  PhotoDetailController.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.04.2023.
//

import UIKit
import Kingfisher

class PhotoDetailController {
    let photoId: String
    init(photoId: String) {
        self.photoId = photoId
    }

    func fetchPhotoData() async throws -> Photo {
        let photoData = try await PhotoDataRequest().fetchPhotoData(photoId: photoId)
        return photoData
    }
}
