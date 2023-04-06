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
    static func pageQueryItems(searchWord: String, page: Int) -> [URLQueryItem] {
        [
            "page": "\(page)",
            "per_page": "30",
            "query": searchWord
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
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
    func sendRequest(with urlRequest: URLRequest) async throws -> Response {
//        let urlRequest = URLRequest.init(
//            path: category,
//            queryItems: Array.pageQueryItems(searchWord: searchWord, itemsPerPage: itemsPerPage, page: page)
//        )
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkErrors.searchDataNotFound
        }

        let photoData = try decodeResponse(data: data)

        return photoData
    }
}

