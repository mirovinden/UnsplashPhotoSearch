//
//  SearchView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 05.04.2023.
//

import UIKit

class SearchCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        register(ImageInfoCell.self, forCellWithReuseIdentifier: ImageInfoCell.identifier)
        register(UserInfoCell.self, forCellWithReuseIdentifier: UserInfoCell.identifier)
        register(CollectionsHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "header")
        
        backgroundColor = .white
    }
}
