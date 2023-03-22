//
//  ImageInfoCell.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 15.02.2023.
//

import UIKit
import Kingfisher

class ImageInfoCell: UICollectionViewCell {
    var imageView: UIImageView = .init()
    var descriptionLabel: UILabel = .init()
    var urlLabel: UILabel = .init()


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

//        setupConstraints()
    }

    func configure(photoItem: UnsplashPhoto) async {
        descriptionLabel.text = photoItem.description ?? photoItem.alternativeDescription
        imageView.image = UIImage(systemName: "photo")

        do {
            let image = try await PhotoSearchRequest().imageRequest(url: photoItem.photoURL.regular)
            self.imageView.image = image
            imageView.frame = contentView.bounds
        } catch {
            print(error)
        }

    }

//    private func setupConstraints() {
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            imageView.topAnchor.constraint(equalTo: self.topAnchor),
//            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
//        ])
//    }

}
