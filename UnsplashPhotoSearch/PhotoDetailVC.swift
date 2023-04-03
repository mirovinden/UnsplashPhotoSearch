//
//  PhotoDetailViewController.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 31.03.2023.
//

import UIKit
import Kingfisher

class PhotoDetailViewController: UIViewController {
    let photoDetailController: PhotoDetailController
    let imageView: UIImageView = .init()

    let likesLabel: UILabel = .init()
    let likesButton: UIButton = .init()
    let likesStackView: UIStackView = .init()
    var photoIsLiked: Bool = false {
        didSet {
            likesButton.setNeedsUpdateConfiguration()
        }
    }
    
    var photo: Photo!
    
    init(controller: PhotoDetailController) {
        self.photoDetailController = controller
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
            self.photo = try await photoDetailController.fetchPhotoData()
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

private extension PhotoDetailViewController {
    func setupUI() {
        view.addSubview(imageView)
        view.addSubview(likesStackView)
        view.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity

        likesStackView.addArrangedSubview(likesButton)
        likesStackView.addArrangedSubview(likesLabel)
        likesStackView.axis = .vertical
        likesStackView.alignment = .trailing
        likesStackView.distribution = .fillEqually

        likesLabel.text = "1502"
        likesLabel.textColor = .red

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
            UIAction { _ in
                self.photoIsLiked = !self.photoIsLiked
            },
            for: .touchUpInside
        )
    }

    func setupConstraints() {
        likesStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            likesLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            likesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
        ])

    }
}
