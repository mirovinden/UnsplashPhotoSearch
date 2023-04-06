
//
//  SearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit
import Kingfisher


class SearchViewController: UIViewController, UISearchBarDelegate {
    private let searchController: UISearchController = .init()
   
    let searchView: SearchView = .init()
    private let dataSearchController = SearchController()

    var pageNumber: Int = 1
    let searchCategory = ["photos", "collections", "users"]
    var category = QueryOptions.photos

    var searchTask: Task<Void, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMatchingItems()
    }

    @objc func fetchMatchingItems() {
        let searchCategory = searchCategory[searchController.searchBar.selectedScopeButtonIndex]
        let searchWord = "panda"
        let segmentIndex = searchView.itemPerPageView.segmentedControl.selectedSegmentIndex
        guard let itemsPerPage = searchView.itemPerPageView.segmentedControl.titleForSegment(at: segmentIndex) else { return }
        
        category = QueryOptions.init(rawValue: searchController.searchBar.selectedScopeButtonIndex)!
        let urlRequest = URLRequest(
            path: searchCategory,
            queryItems: Array.pageQueryItems(searchWord: searchWord, itemsPerPage: itemsPerPage, page: pageNumber)
        )
        searchTask?.cancel()
        searchTask = Task {
            do {
                try await dataSearchController.searchItems(with: urlRequest, category: category)
                searchView.collectionView.collectionViewLayout = dataSearchController.createLayout(cater: category)
            } catch {
                print(error)
            }

            searchTask?.cancel()
        }
    }
    @objc func pageButtonsClicked(sender: UIButton) {
        searchView.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        sender == searchView.pageNumberView.previousPageButton ? (pageNumber -= 1) : (pageNumber += 1)
        searchView.pageNumberView.pageNumberLabel.text = String(pageNumber)
        searchView.pageNumberView.previousPageButton.isEnabled = pageNumber == 1 ? false : true

        fetchMatchingItems()
    }
//
    // searchControllerDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchView.pageNumberView.pageNumberLabel.text = "1"
        pageNumber = 1
        searchView.pageNumberView.previousPageButton.isEnabled = false
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
        view.addSubview(searchView)
        view.backgroundColor = .white
        dataSearchController.onEvent = { [unowned self] event in
            self.handleSearchControllerEvent(event)
        }

        searchView.itemPerPageView.onEvent = { self.fetchMatchingItems() }
        searchView.pageNumberView.onEvent = { button in
            self.pageButtonsClicked(sender: button)
        }

        searchView.collectionView.delegate = dataSearchController
        searchView.collectionView.dataSource = dataSearchController
        navigationItem.searchController = searchController

        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.showsScopeBar = true

        searchController.searchBar.scopeButtonTitles = ["Photos","Collections", "Users"]
        searchController.searchBar.searchTextField.addAction(
            UIAction { _ in
                self.fetchMatchingItems()
                self.searchView.collectionView.reloadData()

            },
            for: .valueChanged
        )
//        addTarget(self, action: #selector(fetchMatchingItems), for: .valueChanged)
        searchController.searchBar.layer.backgroundColor = .init(gray: 10, alpha: 1)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }

    
}
