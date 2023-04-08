//
//  SearchController.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 03.04.2023.
//

import UIKit

enum SearchCategory: String {
    case photos
    case collections
    case users
}

class SearchController: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

    enum Event {
        case photoSelected(Photo)
        case collectionSelected(Collection)
        case userSelected(User)
    }

    enum IndexType {
        case sectioned([Int])
        case itemed([Int])
    }
    
    var photoSearchData: [Photo] = []
    var collectionSearchData: [Collection] = []
    var userSearchData: [User] = []

    var onEvent: ((Event) -> Void)?
    var scrollEvent: ((IndexType) -> Void)?

    var category = SearchCategory.photos
    var request: URLRequest?
    var pageNumber: Int = 1
    var searchWord = String()

    func searchItems(with word: String, category: String) async throws {
        self.category = SearchCategory(rawValue: category)!
        let urlRequest = URLRequest(
            path: category,
            queryItems: Array.pageQueryItems(searchWord: word, page: pageNumber)
        )

        self.request = urlRequest
        self.searchWord = word
        
        switch self.category {
        case .photos:
            let photosData = try await PhotosSearchRequest().sendRequest(with: urlRequest)
            self.photoSearchData.append(contentsOf: photosData)
        case .collections:
            let collectionsData = try await CollectionsSearchRequest().sendRequest(with: urlRequest)
            self.collectionSearchData.append(contentsOf: collectionsData)
        case .users:
            let usersData = try await UsersSearchRequest().sendRequest(with: urlRequest)
            self.userSearchData.append(contentsOf: usersData)
        }
    }
    


    func createLayout() -> UICollectionViewCompositionalLayout {
        switch self.category {
        case .photos:
            return UICollectionViewCompositionalLayout.photoSearchLayout
        case .collections:
            return UICollectionViewCompositionalLayout.collectionsSearchLayout
        case .users:
            return UICollectionViewCompositionalLayout.usersSearchLayout
        }
    }
    
    
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
        switch category {
        case .photos:
            let photo = photoSearchData[indexPath.item]
            onEvent?(.photoSelected(photo))
        case .collections:
            let collection = collectionSearchData[indexPath.section]
            onEvent?(.collectionSelected(collection))
        case .users:
            let user = userSearchData[indexPath.item]
            onEvent?(.userSelected(user))
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        var startIndex: Int
        var lefted: Int

        switch category {
        case .photos:
            startIndex = photoSearchData.count
            lefted = photoSearchData.count - indexPath.item
        case .collections:
            startIndex = collectionSearchData.count
            if indexPath.item == 0 {
                lefted = collectionSearchData.count - indexPath.section
            } else {
                lefted = 5
            }
        case .users:
            startIndex = userSearchData.count
            lefted = userSearchData.count - indexPath.item
        }

        let itemRange = Array(startIndex...startIndex + 29)

        if lefted == 25 {

            Task {
                do {
                    pageNumber += 1
                    try await searchItems(with: searchWord, category: category.rawValue)
                    switch category {
                    case .collections:
                        scrollEvent?(.sectioned(itemRange))
                    default:
                        scrollEvent?(.itemed(itemRange))
                    }
                } catch {
                    print(error)
                }

            }
        }
    }
}
