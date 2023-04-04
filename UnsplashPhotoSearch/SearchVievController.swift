
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

    let previousPageButton = UIButton(configuration: .borderless())
    let nextPageButton = UIButton(configuration: .borderless())
    let pageNumberLabel = UILabel()
    let pageStackView = UIStackView()

    
    var pageNumber: Int = 1
    let searchCategory = ["photos", "collections", "users"]
    var category = QueryOptions.photos

    var searchTask: Task<Void, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

       
        fetchMatchingItems()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if additionalSafeAreaInsets.top != stackView.frame.height {
            additionalSafeAreaInsets.top = stackView.frame.height
        }
    }

    @objc func fetchMatchingItems() {
        let searchCategory = searchCategory[searchController.searchBar.selectedScopeButtonIndex]
        let searchWord = "panda"
        let segmentIndex = itemsPerPageSegmentedControl.selectedSegmentIndex
        guard let itemsPerPage = itemsPerPageSegmentedControl.titleForSegment(at: segmentIndex) else { return }
        
        category = QueryOptions.init(rawValue: searchController.searchBar.selectedScopeButtonIndex)!
        let urlRequest = URLRequest(
            path: searchCategory,
            queryItems: Array.pageQueryItems(searchWord: searchWord, itemsPerPage: itemsPerPage, page: pageNumber)
        )
        searchTask?.cancel()
        searchTask = Task {
            do {
                try await dataSearchController.searchItems(with: urlRequest, category: category)
                collectionView.collectionViewLayout = dataSearchController.createLayout(cater: category)
                collectionView.reloadData()
            } catch {
                print(error)
            }

            searchTask?.cancel()
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

    private func handleSearchControllerEvent(_ event: SearchController.Event) {
        switch event {
        case .photoSelected(let photo):
            let photoDetailVC = PhotoViewController(photo: photo)
            self.show(photoDetailVC, sender: nil)
        case .collectionSelected(let collection):
            let collectionDetailVC = CollectionDetailViewController(photoUrl: collection.photosURL)
            self.show(collectionDetailVC, sender: nil)
        }
    }

    func setupUI() {
        dataSearchController.onEvent = { [unowned self] event in
            self.handleSearchControllerEvent(event)
        }

        collectionView.register(ImageInfoCell.self, forCellWithReuseIdentifier: ImageInfoCell.identifier)
        collectionView.register(UserInfoCell.self, forCellWithReuseIdentifier: UserInfoCell.identifier)
        collectionView.register(CollectionsHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "header")
        
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
