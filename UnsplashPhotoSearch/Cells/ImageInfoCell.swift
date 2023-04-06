//
//  ImageInfoCell.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 15.02.2023.
//

import UIKit
import Kingfisher

class ImageInfoCell: UICollectionViewCell {
    static let identifier = "Cell"
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
    }

    func configure(with photoData: Photo) {

        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: photoData.photoURL.small,
            placeholder: UIImage.blurHash(from: photoData),
            options: [.transition(.fade(0.3))]
        )
    }

    func configure(with preview: PreviewPhoto) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: preview.photoURL.thumb,
            placeholder: UIImage(blurHash: preview.blurHash ?? "", size: CGSize(width: 30, height: 30), punch: 1),
            options: [.transition(.fade(0.3))]
        )
    }
}
