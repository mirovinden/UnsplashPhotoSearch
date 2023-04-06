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
    }
    
    var photoSearchData: [Photo] = []
    var collectionSearchData: [Collection] = []
    var userSearchData: [User] = []

    var onEvent: ((Event) -> Void)?
    var pageEvent: (([IndexPath]) -> Void)?
 
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
            self.collectionSearchData = collectionsData
        case .users:
            let usersData = try await UsersSearchRequest().sendRequest(with: urlRequest)
            self.userSearchData = usersData
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
            return
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let startIndex = photoSearchData.count
        let itemRange = Array(startIndex...startIndex + 29)
        let newIndexPath = itemRange.map { item in
            IndexPath(item: item, section: 0)

        }

        if indexPath.item % 29 == 0 {
            print("Neew request")
            Task {
                do {
                    pageNumber += 1
                  try await searchItems(with: searchWord, category: category.rawValue)
                    pageEvent?(newIndexPath)
                } catch {
                    print(error)
                }

            }
        }
    }
}

