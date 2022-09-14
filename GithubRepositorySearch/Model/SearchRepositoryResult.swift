//
//  SearchRepositoryResult.swift
//  GithubRepositorySearch
//
//  Created by Muhammad Syah Royni on 13/09/22.
//

import Foundation

struct SearchRepositoryResult: Decodable {
	
	var totalCount: Int
	var items: [RepositoryModel]
	
	enum SearchRepositoryResultCodingKeys: String, CodingKey {
		case totalCount = "total_count"
		case items
   }
	
	init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: SearchRepositoryResultCodingKeys.self)
		totalCount = try container.decode(Int.self, forKey: .totalCount)
		items = try container.decode([RepositoryModel].self, forKey: .items)
	}
}
