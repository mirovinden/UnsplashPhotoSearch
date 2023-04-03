//
//  SearchController.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 03.04.2023.
//

import UIKit


class SearchController: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

    var photoSearchData: [Photo] = []
    var collectionSearchData: [Collection] = []
    var userSearchData: [User] = []
    
    enum QueryOptions: Int {
        case photos
        case collections
        case users
    }

    var category = QueryOptions.photos

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch category {
        case .photos:
            return 1
        case .collections:
            return collectionSearchData.count
        case .users:
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch category {
        case .photos:
            return photoSearchData.count
        case .collections:
            return collectionSearchData[section].photoPreviews.count
        case .users:
            return userSearchData.count
        }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch category{
        case .photos:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
            let item = photoSearchData[indexPath.item]
            cell.configure(with: item)

            return cell
        case .collections:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
            let item = collectionSearchData[indexPath.section].photoPreviews[indexPath.item]
            cell.configure(with: item)

            return cell
        case .users:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoCell.identifier, for: indexPath) as! UserInfoCell

            let item = userSearchData[indexPath.item]
            cell.configure(with: item)

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: "header", withReuseIdentifier: "header",
            for: indexPath) as! CollectionsHeaderView
        let item = collectionSearchData[indexPath.section]
        header.nameLabel.text = item.title
        header.photoCountLabel.text = "\(item.totalPhotos) photos"

        return header
    }


    //DELEGATE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photoSearchData[indexPath.item]
        let photoDetailVC = PhotoDetailViewController(controller: PhotoDetailController(photoId: photo.id))
        photoDetailVC.imageView.image = UIImage().blurHash(from: photo)
        photoDetailVC.title = photo.user?.username

        show(photoDetailVC, sender: nil)
    }

}

