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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.username = try container.decode(String.self, forKey: .username)

        let customContainer = try decoder.container(keyedBy: CustomKeys.self)
        let imageURL = try customContainer.decode(ProfileImage.self, forKey: .profileImage)
        self.profileImage = imageURL.medium
    }

    enum CustomKeys: String, CodingKey{
        case profileImage = "profile_image"
    }

    struct ProfileImage: Decodable {
        let medium: URL
    }
}


extension User: Hashable, Comparable {
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.id < rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }


}
