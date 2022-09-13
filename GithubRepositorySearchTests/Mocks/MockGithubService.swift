//
//  MockGithubService.swift
//  GithubRepositorySearchTests
//
//  Created by Muhammad Syah Royni on 13/09/22.
//

import Foundation
@testable import GithubRepositorySearch

enum ServiceUseCase {
	case success
	case successThreeItems
	case dataNil
	case invalidData
	case rateLimitExceeded
	case unknwonError
}
class MockGithubService: GithubFacade {
	
	var savedCompletion: ((Result<SearchRepositoryResult, Error>) -> Void)?
	
	func searchRepository(queryString: String, completion: @escaping (Result<SearchRepositoryResult, Error>) -> Void) {
		savedCompletion = completion
	}
	
	func getServiceResponse(usecase: ServiceUseCase) {
		switch usecase {
		case .success:
			if let result = getSuccessTwoItemsResult() {
				savedCompletion?(.success(result))
			} else {
				savedCompletion?(.failure(ResponseError(errorMessage: "", errorCode: 0)))
			}
		case .successThreeItems:
			if let result = getSuccessThreeItemsResult() {
				savedCompletion?(.success(result))
			} else {
				savedCompletion?(.failure(ResponseError(errorMessage: "", errorCode: 0)))
			}
		case .dataNil:
			let error = ResponseError(errorMessage: "The result data is nil", errorCode: 404)
			savedCompletion?(.failure(error))
		case .invalidData:
			let parseError = ResponseError(errorMessage: "Failed to parse the result", errorCode: 400)
			savedCompletion?(.failure(parseError))
		case .rateLimitExceeded:
			let limitRateError = ResponseError(errorMessage: "API rate limit exceeded", errorCode: 403)
			savedCompletion?(.failure(limitRateError))
		case .unknwonError:
			let unknownError = NSError(domain: "asd", code: 0, userInfo: nil)
			savedCompletion?(.failure(unknownError))
		}
	}
	
	func getSuccessTwoItemsResult() -> SearchRepositoryResult? {
		
		let jsonString = "{\"total_count\":2,\"incomplete_results\":false,\"items\":[{\"id\":68911683,\"full_name\":\"daniel-e/tetros\",\"owner\":{\"login\":\"daniel-e\",\"id\":5294331,\"avatar_url\":\"https://avatars.githubusercontent.com/u/5294331?v=4\"},\"html_url\":\"https://github.com/daniel-e/tetros\",\"description\":\"Tetristhatfitsintothebootsector.\",\"updated_at\":\"2022-08-28T04:03:38Z\",\"stargazers_count\":736,\"watchers_count\":736},{\"id\":8688362,\"full_name\":\"havivha/Nand2Tetris\",\"owner\":{\"login\":\"havivha\",\"id\":2629901,\"avatar_url\":\"https://avatars.githubusercontent.com/u/2629901?v=4\"},\"html_url\":\"https://github.com/havivha/Nand2Tetris\",\"description\":\"Computerimplementationasdescribedin\\\"TheElementsofComputingSystems\\\"\",\"updated_at\":\"2022-09-12T14:10:47Z\",\"stargazers_count\":328,\"watchers_count\":328}]}"
		
		if let jsonData = jsonString.data(using: .utf8) {
			let jsonDecoder = JSONDecoder()
			
			if let result = try? jsonDecoder.decode(SearchRepositoryResult.self, from: jsonData) {
				return result
			}
		}
		
		
		return nil
	}
	
	func getSuccessThreeItemsResult() -> SearchRepositoryResult? {
		
		let jsonString = "{\"total_count\":2,\"incomplete_results\":false,\"items\":[{\"id\":68911683,\"full_name\":\"daniel-e/tetros\",\"owner\":{\"login\":\"daniel-e\",\"id\":5294331,\"avatar_url\":\"https://avatars.githubusercontent.com/u/5294331?v=4\"},\"html_url\":\"https://github.com/daniel-e/tetros\",\"description\":\"Tetristhatfitsintothebootsector.\",\"updated_at\":\"2022-08-28T04:03:38Z\",\"stargazers_count\":736,\"watchers_count\":736},{\"id\":8688362,\"full_name\":\"havivha/Nand2Tetris\",\"owner\":{\"login\":\"havivha\",\"id\":2629901,\"avatar_url\":\"https://avatars.githubusercontent.com/u/2629901?v=4\"},\"html_url\":\"https://github.com/havivha/Nand2Tetris\",\"description\":\"Computerimplementationasdescribedin\\\"TheElementsofComputingSystems\\\"\",\"updated_at\":\"2022-09-12T14:10:47Z\",\"stargazers_count\":328,\"watchers_count\":328},{\"id\":123124,\"full_name\":\"havivha/Nand2asd\",\"owner\":{\"login\":\"havivha\",\"id\":2629901,\"avatar_url\":\"https://avatars.githubusercontent.com/u/2629901?v=4\"},\"html_url\":\"https://github.com/havivha/Nand2Tetris\",\"description\":\"Computerimplementationasdescribedin\\\"TheElementsofComputingSystems\\\"\",\"updated_at\":\"2022-09-12T14:10:47Z\",\"stargazers_count\":322,\"watchers_count\":300}]}"
		
		if let jsonData = jsonString.data(using: .utf8) {
			let jsonDecoder = JSONDecoder()
			
			if let result = try? jsonDecoder.decode(SearchRepositoryResult.self, from: jsonData) {
				return result
			}
		}
		
		
		return nil
	}
}
