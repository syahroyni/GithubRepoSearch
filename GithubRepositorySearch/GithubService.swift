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
		
		let urlString = "\(self.baseURL)search/repositories"
		var urlComponents = URLComponents(string: urlString)
		let queryItem = URLQueryItem(name: "q", value: queryString)
		urlComponents?.queryItems = [queryItem]
		
		guard let url = urlComponents?.url else {
			return
		}
		
		restService.fetch(url: url, completion: { data, error in
			
			if let error = error {
				
				completion(.failure(error))
			} else if let data = data {
				
				let decoder = JSONDecoder()
				
				if let searchResult = try? decoder.decode(SearchRepositoryResult.self, from: data) {
					
					completion(.success(searchResult))
				} else {
					let parseError = ResponseError(errorMessage: "Failed to parse the result", errorCode: 400)
					
					completion(.failure(parseError))
				}
			} else {
				
				let dataNilError = ResponseError(errorMessage: "The result data is nil", errorCode: 404)
				completion(.failure(dataNilError))
			}
		})
	}
}
