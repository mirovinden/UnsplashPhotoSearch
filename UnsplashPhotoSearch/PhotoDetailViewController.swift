//
//  PhotoDetailViewController.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 31.03.2023.
//

import UIKit
import Kingfisher

class PhotoDetailViewController: UIViewController {
    let imageView: UIImageView = .init()

    var photo: Photo

    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillLayoutSubviews() {
        imageView.frame = view.bounds
    }
}

private extension PhotoDetailViewController {
    func setupUI() {
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.kf.setImage(
            with: photo.photoURL.regular,
            placeholder: UIImage(blurHash: photo.blurHash, size: CGSize(width: 32, height: 32)),
            options: [.transition(.fade(3))]
        )

    }
}
