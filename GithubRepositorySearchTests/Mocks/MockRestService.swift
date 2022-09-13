//
//  MockRestService.swift
//  GithubRepositorySearchTests
//
//  Created by Muhammad Syah Royni on 13/09/22.
//

import UIKit
@testable import GithubRepositorySearch

class MockRestService: RESTService {

	enum ServiceUseCase {
		case success
		case failed
		case dataNil
		case dataInvalid
		case limitRateExceeded
		case limitRateWithNotJSONData
	}
	
	var savedCompletion: ((Data?, URLResponse?, Error?) -> Void)?
	var savedURL: URL!
	
	override func fetch(url: URL, completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
		savedURL = url
		savedCompletion = completion
	}
	
	func getFetchResponse(useCase: ServiceUseCase) {
		
		switch(useCase) {
		case .success:
			let urlResponse = HTTPURLResponse(url: savedURL, statusCode: 200, httpVersion: nil, headerFields: nil)
			let successData = getSuccessData()
			savedCompletion?(successData, urlResponse, nil)
		case .failed:
			let urlResponse = HTTPURLResponse(url: savedURL, statusCode: 500, httpVersion: nil, headerFields: nil)
			let error = NSError(domain: "unknown error", code: 500, userInfo: nil)
			savedCompletion?(nil, urlResponse, error)
		case .dataNil:
			let urlResponse = HTTPURLResponse(url: savedURL, statusCode: 404, httpVersion: nil, headerFields: nil)
			savedCompletion?(nil, urlResponse, nil)
		case .dataInvalid:
			let urlResponse = HTTPURLResponse(url: savedURL, statusCode: 200, httpVersion: nil, headerFields: nil)
			let invalidData = "invalid Data".data(using: .utf8)
			savedCompletion?(invalidData, urlResponse, nil)
		case .limitRateExceeded:
			let urlResponse = HTTPURLResponse(url: savedURL, statusCode: 403, httpVersion: nil, headerFields: nil)
			let limitExceededData = getLimitExceededData()
			savedCompletion?(limitExceededData, urlResponse, nil)
		case .limitRateWithNotJSONData:
			let urlResponse = HTTPURLResponse(url: savedURL, statusCode: 403, httpVersion: nil, headerFields: nil)
			let singleValueData = "single Data".data(using: .utf8)
			savedCompletion?(singleValueData, urlResponse, nil)
		}
	}
	
	func getSuccessData() -> Data {
		
		let jsonString = "{\"total_count\":2,\"incomplete_results\":false,\"items\":[{\"id\":68911683,\"full_name\":\"daniel-e/tetros\",\"owner\":{\"login\":\"daniel-e\",\"id\":5294331,\"avatar_url\":\"https://avatars.githubusercontent.com/u/5294331?v=4\"},\"html_url\":\"https://github.com/daniel-e/tetros\",\"description\":\"Tetristhatfitsintothebootsector.\",\"updated_at\":\"2022-08-28T04:03:38Z\",\"stargazers_count\":736,\"watchers_count\":736},{\"id\":8688362,\"full_name\":\"havivha/Nand2Tetris\",\"owner\":{\"login\":\"havivha\",\"id\":2629901,\"avatar_url\":\"https://avatars.githubusercontent.com/u/2629901?v=4\"},\"html_url\":\"https://github.com/havivha/Nand2Tetris\",\"description\":\"Computerimplementationasdescribedin\\\"TheElementsofComputingSystems\\\"\",\"updated_at\":\"2022-09-12T14:10:47Z\",\"stargazers_count\":328,\"watchers_count\":328}]}"
		
		if let data = jsonString.data(using: .utf8) {
			return data
		}
		
		return Data()
	}
	
	func getLimitExceededData() -> Data {
		
		let jsonString = "{\"message\":\"APIratelimitexceededfor103.85.62.162.(Buthere'sthegoodnews:Authenticatedrequestsgetahigherratelimit.Checkoutthedocumentationformoredetails.)\",\"documentation_url\":\"https://docs.github.com/rest/overview/resources-in-the-rest-api#rate-limiting\"}"
		
		if let data = jsonString.data(using: .utf8) {
			return data
		}
		
		return Data()
	}
}
