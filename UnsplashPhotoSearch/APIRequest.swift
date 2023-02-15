//
//  APIRequest.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit


enum NetworkErrors: Error {
    case noImagesFound
}

struct PhotoSearchRequest {

    func photoSearch() async throws -> [UnsplashPhoto] {

        let url = URL(string: "https://api.unsplash.com/search/photos?page=2&per_page=30&query=lemon&client_id=ZmifjFVuI-ybPzVC0bjS5fVfOxX8q8KHH813yxMKkhY")!
        let urlRequest = URLRequest(url: url)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)


        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkErrors.noImagesFound
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
