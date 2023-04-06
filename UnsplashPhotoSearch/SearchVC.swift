
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

    let searchCategory = ["photos", "collections", "users"]
    var searchTask: Task<Void, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMatchingItems()
    }

    @objc func fetchMatchingItems() {
        let searchCategory = searchCategory[searchController.searchBar.selectedScopeButtonIndex]
        let searchWord = "panda"

        searchTask?.cancel()
        searchTask = Task {
            do {
                try await dataSearchController.searchItems(with: searchWord, category: searchCategory)
                searchView.collectionView.collectionViewLayout = dataSearchController.createLayout()
                searchView.collectionView.reloadData()

            } catch {
                print(error)
            }

            searchTask?.cancel()
        }
    }

    // searchControllerDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        perform(#selector(fetchMatchingItems), with: nil)
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        fetchMatchingItems()
        dataSearchController.pageNumber = 1
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

        dataSearchController.scrollEvent =  { range in
            switch range {
            case .sectioned(let sections):
                
                print(sections)
                self.searchView.collectionView.insertSections(IndexSet(sections))
            case .itemed(let items):
                let indexes = items.map { IndexPath(item: $0, section: 0)}
                self.searchView.collectionView.insertItems(at: indexes)

            }
//            self.searchView.collectionView.reloadData()

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
