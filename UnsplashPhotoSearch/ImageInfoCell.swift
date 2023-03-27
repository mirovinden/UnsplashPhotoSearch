//
//  ImageInfoCell.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 15.02.2023.
//

import UIKit
import Kingfisher

class ImageInfoCell: UICollectionViewCell {
    let imageView: UIImageView = .init()
    let descriptionLabel: UILabel = .init()
    let urlLabel: UILabel = .init()


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.contentView.bounds
    }


    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8

    }

    func configure(photoURL: URL) {

        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: photoURL,
            placeholder: UIImage(systemName: "photo"),
            options: [.transition(.fade(0.3))]
        )
    }
}
