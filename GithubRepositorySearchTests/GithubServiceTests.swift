//
//  GithubServiceTests.swift
//  GithubRepositorySearchTests
//
//  Created by Muhammad Syah Royni on 13/09/22.
//

import XCTest
@testable import GithubRepositorySearch

class GithubServiceTests: XCTestCase {
	
	var githubService: GithubService!
	var mockRestService: MockRestService = MockRestService()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		githubService = GithubService(restService: mockRestService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
	
	func testValidData() {
		
		var searchRepositoryResult: SearchRepositoryResult?
		
		githubService.searchRepository(queryString: "dummy", page: 1) { result in
			switch(result) {
			case .success(let successResult):
				searchRepositoryResult = successResult
			default:
				break
			}
		}
		mockRestService.getFetchResponse(useCase: .success)
		
		XCTAssertNotNil(searchRepositoryResult)
	}
	
	func testInvalidData() {
		
		var expectedError: ResponseError?
		
		githubService.searchRepository(queryString: "dummy", page: 1) { result in
			switch(result) {
			case .failure(let error):
				expectedError = error as? ResponseError
				
			default:
				break
			}
		}
		mockRestService.getFetchResponse(useCase: .dataInvalid)
		
		XCTAssertNotNil(expectedError)
		XCTAssertEqual(expectedError?.errorCode, 400)
	}
	
	func testLimitRateExceeded() {
		
		var expectedError: ResponseError?
		
		githubService.searchRepository(queryString: "dummy", page: 1) { result in
			switch(result) {
			case .failure(let error):
				expectedError = error as? ResponseError
				
			default:
				break
			}
		}
		mockRestService.getFetchResponse(useCase: .limitRateExceeded)
		
		XCTAssertNotNil(expectedError)
		XCTAssertEqual(expectedError?.errorCode, 403)
	}
	
	func testLimitRateExceededWithNotJSONData() {
		
		var expectedError: ResponseError?
		
		githubService.searchRepository(queryString: "dummy", page: 1) { result in
			switch(result) {
			case .failure(let error):
				expectedError = error as? ResponseError
				
			default:
				break
			}
		}
		mockRestService.getFetchResponse(useCase: .limitRateWithNotJSONData)
		
		XCTAssertNotNil(expectedError)
		XCTAssertEqual(expectedError?.errorCode, 403)
	}
	
	func testDataNil() {
		
		var expectedError: ResponseError?
		
		githubService.searchRepository(queryString: "dummy", page: 1) { result in
			switch(result) {
			case .failure(let error):
				expectedError = error as? ResponseError
				
			default:
				break
			}
		}
		mockRestService.getFetchResponse(useCase: .dataNil)
		
		XCTAssertNotNil(expectedError)
		XCTAssertEqual(expectedError?.errorCode, 404)
	}
	
	func testErrorFetch() {
		
		var expectedError: ResponseError?
		
		githubService.searchRepository(queryString: "dummy", page: 1) { result in
			switch(result) {
			case .failure(let error):
				expectedError = error as? ResponseError
				
			default:
				break
			}
		}
		mockRestService.getFetchResponse(useCase: .failed)
		
		XCTAssertNil(expectedError)
	}

}
