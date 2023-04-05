//
//  SearchView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 05.04.2023.
//

import UIKit

class SearchView: UIView {
    let collectionView: SearchCollectionView =  .init(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
    let itemPerPageView: ItemPerPageView = .init()
    let pageNumberView: PageNumberView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        addSubview(collectionView)
        addSubview(itemPerPageView)
        addSubview(pageNumberView)
        backgroundColor = .white

        setupConstraints()
    }
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        itemPerPageView.translatesAutoresizingMaskIntoConstraints = false
        pageNumberView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            itemPerPageView.topAnchor.constraint(equalTo: topAnchor),
            itemPerPageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            itemPerPageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            itemPerPageView.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: itemPerPageView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            pageNumberView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 140),
            pageNumberView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -140),
            pageNumberView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            pageNumberView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
