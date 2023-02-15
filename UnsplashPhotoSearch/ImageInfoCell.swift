//
//  ImageInfoCell.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 15.02.2023.
//

import UIKit

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

    func configure(photoItem: UnsplashPhoto) async {
        descriptionLabel.text = photoItem.description ?? photoItem.alternativeDescription
        imageView.image = UIImage(systemName: "photo")

        do {
            let image = try await PhotoSearchRequest().imageRequest(url: photoItem.photoURL.full)
            self.imageView.image = image
        } catch {
            print(error)
        }

    }


    private func setupUI() {
        self.backgroundColor = .systemGray5
        self.addSubview(imageView)
        self.addSubview(descriptionLabel)
        imageView.contentMode = .scaleAspectFit
        descriptionLabel.numberOfLines = 2


        setupConstraints()
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        urlLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5)
        ])


    }

}
