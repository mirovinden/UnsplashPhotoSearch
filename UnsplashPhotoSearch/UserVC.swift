//
//  UserDetailsVC.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 04.04.2023.
//

import UIKit
import Kingfisher

class UserViewController: UIViewController {
    let userInfoView = UserDetailInfoView()
    let userMediaView = UserMediaView()
    let image: UIImageView = .init()
    
    let userController = UserController()
    let user: User
    var fetchUserMediaTask: Task<Void, Never>?
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchUserMedia()
    }

    func fetchUserMedia() {
        
        fetchUserMediaTask = Task {
            do {
                try await userController.fetchUserMedia(category: userMediaView.selectedMediaType(), links: user.links)
                userMediaView.collectionView.collectionViewLayout = userController.createLayout()
                userMediaView.collectionView.reloadData()
                
            } catch {
                print(error)
            }
        }
    }
}

private extension UserViewController {
    func setup() {
        view.backgroundColor = .white
        view.addSubview(userInfoView)
        view.addSubview(userMediaView)
        
        userMediaView.collectionView.dataSource = userController
        userMediaView.collectionView.delegate = userController

        userInfoView.profileImage.kf.setImage(with: user.profileImage)
        userInfoView.usernameLabel.text = "@\(user.username)"
        userInfoView.firstNameLabel.text = user.name

        setupConstraints()
    }

    func setupConstraints() {
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        userMediaView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            userMediaView.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 10),
            userMediaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userMediaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userMediaView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
    }
}

