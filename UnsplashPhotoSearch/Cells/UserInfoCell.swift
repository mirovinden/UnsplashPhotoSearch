//
//  UserInfoCell.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 30.03.2023.
//

import UIKit
import Kingfisher

private extension CGFloat {
    static let imageBottomInset: CGFloat = 3
}
class UserInfoCell: UICollectionViewCell {
    static let identifier = "UserCell"

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)

        return label
    }()

    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 11)

        return label
    }()

    let lineView: UIView = .init()
    let imageView: UIImageView = .init()
    let stackView: UIStackView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = (contentView.bounds.height - .imageBottomInset) / 2
    }




    private func setupUI() {
        contentView.addSubview(stackView)
        contentView.addSubview(imageView)
        contentView.addSubview(lineView)
        contentView.clipsToBounds = true

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(userNameLabel)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually

        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        lineView.backgroundColor = .systemGray2
        setupConstraints()
    }
    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.imageBottomInset),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),

            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.imageBottomInset),

            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }

    func configure(with userData: User) {
        userNameLabel.text = userData.username
        nameLabel.text = userData.name
        let processor = RoundCornerImageProcessor(cornerRadius: imageView.bounds.height / 2)

        imageView.kf.setImage(
            with: userData.profileImage,
            placeholder: UIImage(systemName: "photo"),
            options: [.transition(.fade(0.3)), .processor(processor)]
        )
    }
}
