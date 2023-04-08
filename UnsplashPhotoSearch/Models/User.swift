//
//  UsersSearchData.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 30.03.2023.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let username: String
    let profileImage: URL
    let location: String?
    let links: UserLinks

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.username = try container.decode(String.self, forKey: .username)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.links = try container.decode(UserLinks.self, forKey: .links)
        let customContainer = try decoder.container(keyedBy: CustomKeys.self)
        let imageURL = try customContainer.decode(ProfileImage.self, forKey: .profileImage)
        
        self.profileImage = imageURL.large
    }
    
    enum CustomKeys: String, CodingKey{
        case profileImage = "profile_image"
    }
    
    struct ProfileImage: Codable {
        let large: URL
    }
    
    
}

extension User: Hashable, Comparable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.id < rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct UserLinks: Codable {
    let photos: URL
    let likes: URL
}
