
//
//  SearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit
import Kingfisher

class SearchViewController: UINavigationController, UISearchBarDelegate {

    private let collectionView: UICollectionView = .init(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
    private let searchController: UISearchController = .init()
    private let itemsPerPageSegmentedControl = UISegmentedControl()
    private let itemsPerPageLabel = UILabel()
    private let stackView = UIStackView()
    private let dataSearchController = SearchController()

    var pageNumber: Int = 1
    let queryOptions = ["photos", "collections", "users"]

    enum QueryOptions: Int {
        case photos
        case collections
        case users
    }

    var category = QueryOptions.photos

    var photoSearchData: [Photo] = []
    var collectionSearchData: [Collection] = []
    var userSearchData: [User] = []

    let previousPageButton = UIButton(configuration: .borderless())
    let nextPageButton = UIButton(configuration: .borderless())
    let pageNumberLabel = UILabel()
    let pageStackView = UIStackView()

    var SearchTask: Task<Void, Never>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        collectionView.register(ImageInfoCell.self, forCellWithReuseIdentifier: ImageInfoCell.identifier)
        collectionView.register(UserInfoCell.self, forCellWithReuseIdentifier: UserInfoCell.identifier)
        collectionView.register(CollectionsHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "header")
        fetchMatchingItems()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if additionalSafeAreaInsets.top != stackView.frame.height {
            additionalSafeAreaInsets.top = stackView.frame.height
        }
    }



    @objc func fetchMatchingItems() {
        let searchCategory = queryOptions[searchController.searchBar.selectedScopeButtonIndex]
        let searchWord = "ocean"
        let segmentIndex = itemsPerPageSegmentedControl.selectedSegmentIndex
        guard let itemsPerPage = itemsPerPageSegmentedControl.titleForSegment(at: segmentIndex) else { return }

        category = QueryOptions.init(rawValue: searchController.searchBar.selectedScopeButtonIndex)!

        SearchTask?.cancel()
        SearchTask = Task {
            do {

                switch category {
                case .photos:
                    let photosData = try await PhotosSearchRequest().sendRequest(
                        category: searchCategory,
                        searchWord: searchWord,
                        itemsPerPage: itemsPerPage,
                        page: pageNumber
                    )
                    self.photoSearchData = photosData

                case .collections:
                    let collectionsData = try await CollectionsSearchRequest().sendRequest(
                        category: searchCategory,
                        searchWord: searchWord,
                        itemsPerPage: itemsPerPage,
                        page: pageNumber
                    )
                    self.collectionSearchData = collectionsData
                case .users:
                    let usersData = try await UsersSearchRequest().sendRequest(
                        category: searchCategory,
                        searchWord: searchWord,
                        itemsPerPage: itemsPerPage,
                        page: pageNumber
                    )
                    self.userSearchData = usersData

                }
            }
            catch {
                print(error)
            }
            collectionView.reloadData()
            collectionView.collectionViewLayout = createCollectionViewLayout()

            SearchTask = nil
        }
    }

//Data Source

    
    //Layout
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        switch category {
        case.photos:
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
        case .collections:
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/4),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.2)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 4
            )
            group.interItemSpacing = .fixed(3)

            let sectionHeaderSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(44)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: sectionHeaderSize,
                elementKind: "header",
                alignment: .top
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 7, bottom: 10, trailing: 7)
            section.boundarySupplementaryItems = [sectionHeader]
            section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: "background")]
            let layout = UICollectionViewCompositionalLayout(section: section)
            layout.register(SectionBackgroundColor.self, forDecorationViewOfKind: "background")

            return layout
        case .users:
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                            leading: 5,
                                                            bottom: 5,
                                                            trailing: 5)
            section.interGroupSpacing = 5
            
            return UICollectionViewCompositionalLayout(section: section)
            
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

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        fetchMatchingItems()
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
        collectionView.delegate = dataSearchController
        collectionView.dataSource = dataSearchController
        navigationItem.searchController = searchController

        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.showsScopeBar = true

        searchController.searchBar.scopeButtonTitles = ["Photos","Collections", "Users"]
        searchController.searchBar.searchTextField.addTarget(self, action: #selector(fetchMatchingItems), for: .valueChanged)
        searchController.searchBar.layer.backgroundColor = .init(gray: 10, alpha: 1)

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

            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 30),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}




//Data Source, Snapshot, Layout

//func createDataSource() -> DataSourceType {
//    let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, photoItem in
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageInfoCell
//        cell.configure(photoData: photoItem)
//
//        return cell
//    }
//
//    return dataSource
//}
//
//func updateCollectionView() {
//    var snapshot: NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item> {
//        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
//        snapshot.appendSections([0])
//        snapshot.appendItems(photoSearchData,toSection: 0)
//
//        return snapshot
//    }
//    dataSource.apply(snapshot, animatingDifferences: true)
//    }
