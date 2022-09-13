//
//  RepositoryViewModel.swift
//  GithubRepositorySearch
//
//  Created by Muhammad Syah Royni on 13/09/22.
//

import Foundation

class RepositoryViewModel: NSObject {
	
	public var needToReloadData: (() -> Void)?
	public var onNeedToShowAlert: ((String?, String?) -> Void)?
	public var searchingText: String = "" {
		didSet {
			self.searchRepository()
		}
	}
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
					if error.errorCode == 400 {
						self.onNeedToShowAlert?("Data Invalid", error.errorMessage)
					} else if error.errorCode == 404 {
						self.onNeedToShowAlert?("Data Empty", error.errorMessage)
					} else if error.errorCode == 403 {
						self.onNeedToShowAlert?("Rate Limit", error.errorMessage)
					}
				} else {
					self.onNeedToShowAlert?("Error","\(error.localizedDescription)")
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
