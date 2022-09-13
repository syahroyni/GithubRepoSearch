//
//  RepositoryViewModel.swift
//  GithubRepositorySearch
//
//  Created by Muhammad Syah Royni on 13/09/22.
//

import Foundation

class RepositoryViewModel: NSObject {
	
	public var needToReloadData: (() -> Void)?
	public var searchingText: String = ""
	public var listRepositories: [RepositoryModel] = []
	
	private let githubFacade: GithubFacade
	private var searchedText: String = ""
	private var isSearching: Bool = false
	
	init(githubFacade: GithubFacade = GithubService()) {
		self.githubFacade = githubFacade
		super.init()
	}
	
	private func searchRepository() {
			
		if isSearching {
			
			return
		}
		
		searchedText = searchingText
		if searchedText == "" {
			
			return
		}
		
		isSearching = true
		githubFacade.searchRepository(queryString: searchedText) { [weak self] result in
			
			guard let self = self else {
				return
			}
			
			switch(result) {
			case .success(let searchResult):
				if searchResult.totalCount > 0 {
					self.listRepositories = searchResult.items
				} else {
					self.listRepositories = []
				}
				
			case.failure(let error):
				if let error = error as? ResponseError {
					print("Error Code: \(error.errorCode), Message: \(error.errorMessage)")
				} else {
					print(error)
				}
			}
			
			self.isSearching = false
			if (!self.searchedText.elementsEqual(self.searchingText)) {
							
				self.searchRepository()
			} else {
				
				self.needToReloadData?()
			}
		}
	}
}
