//
//  UserPhotosView.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 08.04.2023.
//

import UIKit

class UserMediaView: UIView {
    let collectionView = SearchCollectionView()
    let segmentedControl: UISegmentedControl = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(segmentedControl)
        addSubview(collectionView)

        setupSegmentedControl()
        setupConstraints()
    }

    func selectedMediaType() -> String {
        let index = segmentedControl.selectedSegmentIndex
        let mediaType = segmentedControl.titleForSegment(at: index)!

        return mediaType.lowercased()
    }

    private func setupSegmentedControl() {
        segmentedControl.insertSegment(withTitle: "Photos", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Likes", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Collections", at: 2, animated: false)
        segmentedControl.selectedSegmentIndex = 0
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 8),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -8),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ])

    }

}
