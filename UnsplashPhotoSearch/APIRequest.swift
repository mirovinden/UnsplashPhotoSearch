//
//  APIRequest.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit


enum NetworkErrors: Error {
    case searchDataNotFound
    case photoDataNotFound
}

extension Array where Element == URLQueryItem {
    static func pageQueryItems(searchWord: String, itemsPerPage: String, page: Int) -> [URLQueryItem] {
        ["page": "\(page)", "per_page": itemsPerPage, "query": searchWord]
            .map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

extension URLRequest {
    init(path: String, queryItems: [URLQueryItem]) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"

        components.path = "/search/\(path)"
        components.queryItems = queryItems

        let baseURL = URL(string: components.string!)!

        var urlRequest = URLRequest(url: baseURL)
        urlRequest.setValue("Client-ID ZmifjFVuI-ybPzVC0bjS5fVfOxX8q8KHH813yxMKkhY", forHTTPHeaderField: "Authorization")

        self = urlRequest
    }
}


protocol APIRequest {
    associatedtype Response

    func decodeResponse(data: Data) throws -> Response
}

extension APIRequest where Response: Decodable {
    func sendRequest(category: String, searchWord: String, itemsPerPage: String, page: Int) async throws -> Response {
        let urlRequest = URLRequest.init(
            path: category,
            queryItems: Array.pageQueryItems(searchWord: searchWord, itemsPerPage: itemsPerPage, page: page)
        )
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkErrors.searchDataNotFound
        }

        let photoData = try decodeResponse(data: data)

        return photoData
    }
}

struct PhotosSearchRequest: APIRequest {
    func decodeResponse(data: Data) throws -> [Photo] {
        let photoSearchData = try JSONDecoder().decode(PhotoSearchResults.self, from: data)

        return photoSearchData.results
    }
}

struct CollectionsSearchRequest: APIRequest {
    func decodeResponse(data: Data) throws -> [Collection] {
        let collectionsSearchData = try JSONDecoder().decode(CollectionsSearchResults.self, from: data)
        return collectionsSearchData.results
    }
}

struct UsersSearchRequest: APIRequest {
    func decodeResponse(data: Data) throws -> [User] {
        let usersSearchData = try JSONDecoder().decode(UsersSearchResults.self, from: data)
        return usersSearchData.results
    }
}


struct PhotoDataRequest {
    func fetchPhotoData(photoId: String) async throws -> Photo {
        var components = URLComponents(string: "https://api.unsplash.com")!
        components.path = "/photo/:id\(photoId)"
        let url = URL(string: components.string!)!
        let urlRequest = URLRequest(url: url)

        print(url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkErrors.photoDataNotFound
        }

        let photoData = try JSONDecoder().decode(Photo.self, from: data)

        return photoData
    }
}


