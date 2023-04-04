//
//  PhotoDetailViewController.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 31.03.2023.
//

import UIKit
import Kingfisher

class PhotoViewController: UIViewController {
    let imageView: UIImageView = .init()
    private let likesLabel: UILabel = .init()
    private let likesButton: UIButton = .init()
    private let likesStackView: UIStackView = .init()
    private var photoIsLiked: Bool = false {
        didSet {
            likesButton.setNeedsUpdateConfiguration()
        }
    }
    private let infoButton: UIButton = .init()

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
        view.backgroundColor = .white
        setupUI()
        update()
    }
    
    func update() {
        Task {
            self.photo = try await PhotoDataRequest().fetchPhotoData(photoId: photo.id)
            imageView.kf.setImage(
                with: photo.photoURL.full,
                placeholder: UIImage().blurHash(from: photo),
                options: [.transition(.fade(0.2)),]
            )
        }
    }

    override func viewWillLayoutSubviews() {
        imageView.frame = view.bounds
    }
}

private extension PhotoViewController {
    func setupUI() {
        view.addSubview(imageView)
        view.addSubview(likesStackView)
        view.addSubview(infoButton)
        view.backgroundColor = .black
        title = photo.user?.username
        
        imageView.image = UIImage().blurHash(from: photo)
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity

        likesStackView.addArrangedSubview(likesButton)
        likesStackView.addArrangedSubview(likesLabel)
        likesStackView.axis = .vertical
        likesStackView.alignment = .trailing
        likesStackView.distribution = .fillEqually

        likesLabel.textColor = .red
        likesLabel.text = String(photo.likes ?? 0)

        setupLikeButton()
        setupConstraints()
    }
    
    func setupLikeButton() {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.imagePlacement = .all
        config.baseForegroundColor = .red
        config.preferredSymbolConfigurationForImage = .init(pointSize: 25)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.baseBackgroundColor = .clear
        likesButton.configuration = config
        likesButton.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.image = self.photoIsLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            button.isSelected = self.photoIsLiked
            button.configuration = config
        }
        likesButton.addAction(
            UIAction { _ in self.photoIsLiked = !self.photoIsLiked },
            for: .touchUpInside
        )
        
        infoButton.configuration = config
        infoButton.configuration?.image = UIImage(systemName: "info.circle.fill")
        infoButton.configuration?.baseForegroundColor = .gray
        infoButton.addAction(
            UIAction { _ in
                self.present(PhotoDetailViewController(location: self.photo.location!), animated: true)
            },
            for: .touchUpInside
        )
    }

    func setupConstraints() {
        likesStackView.translatesAutoresizingMaskIntoConstraints = false
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likesLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            likesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            
            infoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            infoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),

        ])

    }
}
