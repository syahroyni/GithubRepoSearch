//
//  RepositoryModel.swift
//  GithubRepositorySearch
//
//  Created by Muhammad Syah Royni on 13/09/22.
//

import Foundation

struct RepositoryModel: Decodable {
	var id: Int
	var fullName: String
	var htmlUrl: String
	var owner: Owner
	var description: String?
	var lastUpdate: String
	var watchersCount: Int
	var starsCount: Int
	
	enum RepositoryCodingKeys: String, CodingKey {
		case id, owner, description
		case fullName = "full_name"
		case updatedAt = "updated_at"
		case htmlUrl = "html_url"
		case stargazersCount = "stargazers_count"
		case watchersCount = "watchers_count"
   }
	
	init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: RepositoryCodingKeys.self)
		id = try container.decode(Int.self, forKey: .id)
		fullName = try container.decode(String.self, forKey: .fullName)
		htmlUrl = try container.decode(String.self, forKey: .htmlUrl)
		owner = try container.decode(Owner.self, forKey: .owner)
		description = try container.decodeIfPresent(String.self, forKey: .description)
		lastUpdate = try container.decode(String.self, forKey: .updatedAt)
		watchersCount = try container.decode(Int.self, forKey: .watchersCount)
		starsCount = try container.decode(Int.self, forKey: .stargazersCount)
	}
}

struct Owner: Decodable {
	var id: Int
	var username: String
	var avatarURL: String
	
	enum OwnerCodingKeys: String, CodingKey {
		case id, login
		case avatarUrl = "avatar_url"
	}
	
	init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: OwnerCodingKeys.self)
		id = try container.decode(Int.self, forKey: .id)
		username = try container.decode(String.self, forKey: .login)
		avatarURL = try container.decode(String.self, forKey: .avatarUrl)
	}
}
