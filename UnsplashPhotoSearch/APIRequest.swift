//
//  APIRequest.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit


enum NetworkErrors: Error {
    case ImageDataNotFound
    case noImagesFound
}

struct PhotoSearchRequest {

    func photoSearchRequest(searchWord: String, itemsPerPage: String, page: Int) async throws -> [UnsplashPhoto] {

        let query = [
            "page": "\(page)",
            "per_page": itemsPerPage,
            "query": searchWord
        ]
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        let baseURL = URL(string: components.string!)!

        var urlRequest = URLRequest(url: baseURL)
        urlRequest.setValue("Client-ID ZmifjFVuI-ybPzVC0bjS5fVfOxX8q8KHH813yxMKkhY", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkErrors.ImageDataNotFound
        }

        
        let photos = try JSONDecoder().decode(PhotoSearch.self, from: data)

        return photos.results
    }

    func imageRequest(url: String) async throws -> UIImage? {
        let url = URL(string: url)!
        let urlRequest = URLRequest(url: url)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkErrors.noImagesFound
        }

        let image = UIImage(data: data)

        return image
    }
}
