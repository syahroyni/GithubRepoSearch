//
//  GithubFacade.swift
//  GithubRepositorySearch
//
//  Created by Muhammad Syah Royni on 13/09/22.
//

import Foundation

protocol GithubFacade {
	func searchRepository(queryString: String, completion: @escaping (Result<SearchRepositoryResult, Error>) -> Void)
}
