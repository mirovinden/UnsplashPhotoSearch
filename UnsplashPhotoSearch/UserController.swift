//
//  UserController.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 08.04.2023.
//

import UIKit

class UserController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var userPhotos: [Photo] = []
    var userLikedPhotos: [Photo] = []
    var userCollections: [Collection] = []
    
    enum UserMediaType: String {
        case photos
        case likes
        case collections
    }
    
    private var mediaType = UserMediaType.photos
    
    func fetchUserMedia(category: String, links: UserLinks) async throws {
        print(category)
        mediaType = UserMediaType(rawValue: category)!
        
        switch mediaType{
        case .photos:
            var urlRequest = URLRequest(url: links.photos)
            urlRequest.setValue("Client-ID ZmifjFVuI-ybPzVC0bjS5fVfOxX8q8KHH813yxMKkhY", forHTTPHeaderField: "Authorization")

            let photos = try await UserPhotosRequest().sendRequest(with: urlRequest)
            userPhotos = photos
            
        case .likes:
            let urlRequest = URLRequest(url: links.likes)
            let photos = try await PhotosSearchRequest().sendRequest(with: urlRequest)
            userLikedPhotos = photos
        case .collections:
            return
        }
    }
    
    
    
    //Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch mediaType {
        case .collections:
            return userCollections.count
        default:
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch mediaType{
        case .photos:
            return userPhotos.count
        case .likes:
            return userLikedPhotos.count
        case .collections:
            return userCollections[section].photoPreviews.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch mediaType {
        case .photos:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
            let item = userPhotos[indexPath.item]
            cell.configure(with: item)
            
            return cell
        case .collections:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
            let item = userCollections[indexPath.section].photoPreviews[indexPath.item]
            cell.configure(with: item)
            
            return cell
        case .likes:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
            
            let item = userLikedPhotos[indexPath.item]
            cell.configure(with: item)
            
            return cell
        }
    }
    
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        switch mediaType {
        case .collections:
            return UICollectionViewCompositionalLayout.collectionsSearchLayout
        default:
            return UICollectionViewCompositionalLayout.photoSearchLayout
        }
    }
    
}
