//
//  SearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit

class SearchViewController: UIViewController {

    var collectionView: UICollectionView = .init(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
    var searchController: UISearchBar = .init()

    var photoSearchData: [UnsplashPhoto] = []
    var dataSource: DataSourceType!

    var photoSearchTask: Task<Void, Never>? = nil
    var imageViewLoadTask: [IndexPath: Task<Void, Never>] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        collectionView.register(ImageInfoCell.self, forCellWithReuseIdentifier: "cell")
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createCollectionViewLayout()
        photoSearchTask?.cancel()
        photoSearchTask = Task {
            do {
                let photosData = try await PhotoSearchRequest().photoSearch()
                self.photoSearchData = photosData
                updateCollectionView()
            }
            catch {
                print(error)
            }
            photoSearchTask = nil
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        updateCollectionView()
    }


    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, photoItem in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageInfoCell

            self.imageViewLoadTask[indexPath]?.cancel()
            self.imageViewLoadTask[indexPath] = Task {
                await cell.configure(photoItem: photoItem)
                self.imageViewLoadTask[indexPath] = nil
            }

            return cell
        }

        return dataSource
    }

    func updateCollectionView() {
        var snapshot: NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item> {
            var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
            snapshot.appendSections([0])
            snapshot.appendItems(photoSearchData,toSection: 0)

            return snapshot
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 2)
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension SearchViewController {

    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>

    enum ViewModel: Hashable {
        typealias Section = Int

        typealias Item = UnsplashPhoto
        }

}

extension SearchViewController {
    private func setupUI() {
        view.addSubview(searchController)
        view.addSubview(collectionView)
        view.backgroundColor = .systemGray3

        collectionView.backgroundColor = .white

        setupConstraints()
    }

    private func setupConstraints() {

        searchController.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchController.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchController.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchController.heightAnchor.constraint(equalToConstant: 50),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchController.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
