//
//  PhotoDetailViewController.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 31.03.2023.
//

import UIKit
import Kingfisher

class PhotoViewController: UIViewController {
    let photoView: PhotoView = .init()

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
        update()
    }
    
    func update() {
        Task {
            self.photo = try await PhotoDataRequest().fetchPhotoData(photoId: photo.id)
            photoView.imageView.kf.setImage(
                with: photo.photoURL.full,
                placeholder: UIImage().blurHash(from: photo),
                options: [.transition(.fade(0.2)),]
            )
        }
    }

    override func viewWillLayoutSubviews() {
        photoView.frame = view.bounds
    }
}

private extension PhotoViewController {
    func setupUI() {
        view.addSubview(photoView)
        title = photo.user?.username

        photoView.imageView.image = UIImage().blurHash(from: photo)
        photoView.imageView.kf.indicatorType = .activity

        photoView.infoButtonEvent = {
            let detailVc = PhotoDetailViewController(location: self.photo.location!)
            self.present(UINavigationController(rootViewController: detailVc), animated: true)
        }

    }
}
