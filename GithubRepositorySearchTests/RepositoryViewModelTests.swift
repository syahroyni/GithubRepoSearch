//
//  RepositoryViewModelTests.swift
//  GithubRepositorySearchTests
//
//  Created by Muhammad Syah Royni on 13/09/22.
//

import XCTest
@testable import GithubRepositorySearch

class RepositoryViewModelTests: XCTestCase {

	var viewModel: RepositoryViewModel!
	var mockGithubService: MockGithubService = MockGithubService()
	
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		viewModel = RepositoryViewModel(githubFacade: mockGithubService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
	
	func testSearchValidRepository() {
		viewModel.searchingText = "dummy"
		mockGithubService.getServiceResponse(usecase: .success)
		XCTAssertEqual(viewModel.listRepositories.count, 2)
	}
	
	func testNewSearchWhenLastSearchingNotFinished() {
		viewModel.searchingText = "dummy"
		viewModel.searchingText = "dummy2"
		XCTAssertEqual(mockGithubService.savedQuery, "dummy")
	}
	
	func testSearchLimitRate() {
		viewModel.searchingText = "dummy"
		mockGithubService.getServiceResponse(usecase: .rateLimitExceeded)
		XCTAssertEqual(viewModel.listRepositories.count, 0)
	}
	
	func testSearchInvalidResponse() {
		viewModel.searchingText = "dummy"
		mockGithubService.getServiceResponse(usecase: .invalidData)
		XCTAssertEqual(viewModel.listRepositories.count, 0)
	}
	
	func testSearchNilData() {
		viewModel.searchingText = "dummy"
		mockGithubService.getServiceResponse(usecase: .dataNil)
		XCTAssertEqual(viewModel.listRepositories.count, 0)
	}
	
	func testSearchUnknownError() {
		viewModel.searchingText="dummy"
		mockGithubService.getServiceResponse(usecase: .unknwonError)
		XCTAssertEqual(viewModel.listRepositories.count, 0)
	}
	
	func testNewSearchExecuteAfterLastSearchFinished() {
		viewModel.searchingText = "dummy"
		viewModel.searchingText = "dummy2"
		mockGithubService.getServiceResponse(usecase: .success)
		XCTAssertEqual(mockGithubService.savedQuery, "dummy2")
		mockGithubService.getServiceResponse(usecase: .successThreeItems)
		XCTAssertEqual(viewModel.listRepositories.count, 3)
	}
	
	func testSearchWithEmptyString() {
		viewModel.searchingText = ""
		mockGithubService.getServiceResponse(usecase: .success)
		XCTAssertEqual(viewModel.listRepositories.count, 0)
	}

}
