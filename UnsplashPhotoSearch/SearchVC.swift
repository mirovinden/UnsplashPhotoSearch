//
//  SearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit
import Kingfisher


class SearchViewController: UIViewController, UISearchBarDelegate {


    private let collectionView: UICollectionView = .init(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
    private let searchController: UISearchController = .init()
    private let itemsPerPageSegmentedControl = UISegmentedControl()
    private let itemsPerPageLabel = UILabel()
    private let stackView = UIStackView()

    var pageNumber: Int = 1

    let previousPageButton = UIButton(configuration: .borderless())
    let nextPageButton = UIButton(configuration: .borderless())
    let pageNumberLabel = UILabel()
    let pageStackView = UIStackView()

    var photoSearchData: [UnsplashPhoto] = []
    var dataSource: DataSourceType!

    var photoSearchTask: Task<Void, Never>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        collectionView.register(ImageInfoCell.self, forCellWithReuseIdentifier: "cell")
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createCollectionViewLayout()
        ImageCache.default.clearDiskCache()
    }

    @objc func fetchMatchingItems() {

        guard let searchWord = searchController.searchBar.text, searchWord != "" else { return }
        let segmentIndex = itemsPerPageSegmentedControl.selectedSegmentIndex
        guard let itemsPerPage = itemsPerPageSegmentedControl.titleForSegment(at: segmentIndex) else {
            return
        }
        
        photoSearchTask?.cancel()
        photoSearchTask = Task {
            do {
                let photosData =
                try await PhotoSearchRequest().photoSearchRequest(searchWord: searchWord, itemsPerPage: itemsPerPage, page: pageNumber)
                self.photoSearchData = photosData
                updateCollectionView()
            }
            catch {
                print(error)
            }
            photoSearchTask = nil
        }
    }

    @objc func pageButtonsClicked(sender: UIButton) {
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        sender == previousPageButton ? (pageNumber -= 1) : (pageNumber += 1)
        pageNumberLabel.text = String(pageNumber)
        previousPageButton.isEnabled = pageNumber == 1 ? false : true

        fetchMatchingItems()
    }

    // searchControllerDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        pageNumberLabel.text = "1"
        pageNumber = 1
        previousPageButton.isEnabled = false
        perform(#selector(fetchMatchingItems), with: nil)
    }

    //Data Source, Snapshot, Layout
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, photoItem in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageInfoCell
            cell.configure(photoURL: photoItem.photoURL.small)

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
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(0.5)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(3)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                        leading: 0,
                                                        bottom: 0,
                                                        trailing: 0)

        return UICollectionViewCompositionalLayout(section: section)
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        print("pre:\(indexPaths)")
//        let urls = indexPaths.map { photoSearchData[$0.row].photoURL.full}
//        ImagePrefetcher(urls: urls).start()
    }
}

// search controller
extension SearchViewController {

    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>

    enum ViewModel: Hashable {
        typealias Section = Int
        typealias Item = UnsplashPhoto
    }
}

//UISetup
private extension SearchViewController {
    func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(pageStackView)
        view.addSubview(stackView)
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        navigationItem.searchController = searchController

        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["Photos","Collections", "Users"]

        itemsPerPageLabel.text = "Photos per page:"
        itemsPerPageLabel.font = .systemFont(ofSize: 14)

        stackView.addArrangedSubview(itemsPerPageLabel)
        stackView.addArrangedSubview(itemsPerPageSegmentedControl)
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5

        pageCountSetup()
        setupSegmentedControl()
        setupConstraints()
    }

    func pageCountSetup() {
        pageStackView.addArrangedSubview(previousPageButton)
        pageStackView.addArrangedSubview(pageNumberLabel)
        pageStackView.addArrangedSubview(nextPageButton)
        pageStackView.distribution = .equalSpacing
        pageStackView.spacing = 5
        pageStackView.backgroundColor = .systemGray3.withAlphaComponent(0.9)
        pageStackView.layer.cornerRadius = 8

        previousPageButton.configuration?.title = "<"
        previousPageButton.isEnabled = false
        previousPageButton.addTarget(self, action: #selector(pageButtonsClicked), for: .touchUpInside)
        nextPageButton.configuration?.title = ">"
        nextPageButton.addTarget(self, action: #selector(pageButtonsClicked), for: .touchUpInside)

        pageNumberLabel.text = "1"
        pageNumberLabel.textColor = .blue
    }

    func setupSegmentedControl() {
        itemsPerPageSegmentedControl.insertSegment(withTitle: "10", at: 0, animated: false)
        itemsPerPageSegmentedControl.insertSegment(withTitle: "20", at: 1, animated: false)
        itemsPerPageSegmentedControl.insertSegment(withTitle: "30", at: 2, animated: false)
        itemsPerPageSegmentedControl.selectedSegmentIndex = 0
        itemsPerPageSegmentedControl.addTarget(self, action: #selector(fetchMatchingItems), for: .valueChanged)
    }

    func setupConstraints() {

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        pageStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            pageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 140),
            pageStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -140),
            pageStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            pageStackView.heightAnchor.constraint(equalToConstant: 30),

            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 30),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: itemsPerPageSegmentedControl.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
