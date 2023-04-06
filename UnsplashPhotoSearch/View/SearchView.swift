//
//  SearchView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 05.04.2023.
//

import UIKit

class SearchView: UIView {
    let collectionView: SearchCollectionView =  .init(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        addSubview(collectionView)
        backgroundColor = .white

        setupConstraints()
    }
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
 
        NSLayoutConstraint.activate([

            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            

        ])
    }
}
