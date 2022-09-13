//
//  GithubService.swift
//  GithubRepositorySearch
//
//  Created by Muhammad Syah Royni on 13/09/22.
//

import Foundation

struct ResponseError: Error {
	var errorMessage: String
	var errorCode: Int
}

class GithubService: GithubFacade {
	
	var restService: RESTService
	let baseURL: String = "https://api.github.com/"
		
	init(restService: RESTService = RESTService()) {
		
		self.restService = restService
	}
	
	func searchRepository(queryString: String, completion: @escaping (Result<SearchRepositoryResult, Error>) -> Void) {
		
	}
}
