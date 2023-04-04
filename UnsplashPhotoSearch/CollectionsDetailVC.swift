//
//  CollectionsDetailVC.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 03.04.2023.
//

import UIKit

class CollectionDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var collectionView: UICollectionView = .init(frame: CGRect(), collectionViewLayout: UICollectionViewCompositionalLayout.photoSearchLayout)
    let photoUrl: URL
    var photosData: [Photo] = []
    var photoRequestTask: Task<Void, Never>?

    init (photoUrl: URL) {
        self.photoUrl = photoUrl
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageInfoCell.self, forCellWithReuseIdentifier: ImageInfoCell.identifier)

        fetchPhotos()
    }

    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
    func fetchPhotos() {
        photoRequestTask?.cancel()
        photoRequestTask = Task {
            do {
                self.photosData = try await FetchPhotos().fetchPhotos(with: photoUrl)
            } catch {
                print(error)
            }
            collectionView.reloadData()
            photoRequestTask?.cancel()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
        let item = photosData[indexPath.item]
        cell.configure(with: item)
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photosData[indexPath.item]
        let photoDetailVC = PhotoViewController(photo: photo)
        
        self.show(photoDetailVC, sender: nil)
    }
}













