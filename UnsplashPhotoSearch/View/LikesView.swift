//
//  LikesView.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 05.04.2023.
//

import UIKit


class LikesView: UIView {
    private let likesStackView: UIStackView = .init()
    let likesLabel: UILabel = .init()
    let likesButton: UIButton = .init()

    private var photoIsLiked: Bool = false {
        didSet {
            likesButton.setNeedsUpdateConfiguration()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(likesStackView)
        likesStackView.addArrangedSubview(likesButton)
        likesStackView.addArrangedSubview(likesLabel)
        likesStackView.axis = .vertical
        likesStackView.alignment = .trailing
        likesStackView.distribution = .fillEqually

        likesLabel.textColor = .red
        likesLabel.text  = "123"

        setupLikeButton()
        setupConstraints()
    }

    private func setupLikeButton() {
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
    }

    func setupConstraints() {
        likesStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likesStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            likesStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            likesStackView.topAnchor.constraint(equalTo: topAnchor),
            likesStackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

    }
}
