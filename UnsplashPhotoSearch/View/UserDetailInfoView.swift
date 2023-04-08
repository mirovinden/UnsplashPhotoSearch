//
//  UserDetailView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 07.04.2023.
//

import UIKit

class UserDetailInfoView: UIView {
    let usernameLabel: UILabel = .init()
    let firstNameLabel: UILabel = .init()
    let lastNameLabel: UILabel = .init()
    let profileImage: UIImageView = .init()
    private let userDataStackView: UIStackView = .init()
    private let labelStackView: UIStackView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setup() {
        addSubview(userDataStackView)

        setupLabels()
        setupStackViews()
        setupConstraints()

    }

    private func setupLabels() {
        usernameLabel.font = UIFont.systemFont(ofSize: 14)
        firstNameLabel.font = UIFont.systemFont(ofSize: 20)
        lastNameLabel.font = UIFont.systemFont(ofSize: 20)
    }

    private func setupStackViews() {
        labelStackView.addArrangedSubview(firstNameLabel)
        labelStackView.addArrangedSubview(lastNameLabel)
        labelStackView.addArrangedSubview(usernameLabel)
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.distribution = .equalSpacing
        labelStackView.spacing = 10

        userDataStackView.addArrangedSubview(profileImage)
        userDataStackView.addArrangedSubview(labelStackView)
        userDataStackView.axis = .horizontal
        userDataStackView.alignment = .leading
        userDataStackView.distribution = .fill
        userDataStackView.spacing = 10
    }

    private func setupConstraints() {
        userDataStackView.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userDataStackView.topAnchor.constraint(equalTo: topAnchor),
            userDataStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            userDataStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            userDataStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
