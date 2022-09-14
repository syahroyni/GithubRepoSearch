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
	private var page: Int = 1
	private var totalCount: Int = 0
	private var hasNextPage: Bool = false
	private var isLoadNextPage: Bool = false
	
	init(githubFacade: GithubFacade = GithubService()) {
		self.githubFacade = githubFacade
		super.init()
	}
	
	func loadNextPage() {
		if !hasNextPage {
			return
		}
		
		page += 1
		self.isLoadNextPage = true
		self.searchRepository()
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
		githubFacade.searchRepository(queryString: searchedText, page: page) { [weak self] result in
			
			guard let self = self else {
				return
			}
			
			switch(result) {
			case .success(let searchResult):
				if self.isLoadNextPage {
					self.listRepositories.append(contentsOf: searchResult.items)
					self.isLoadNextPage = false
					self.needToReloadData?()
				} else {
					
					self.listRepositories = searchResult.items
					self.totalCount = searchResult.totalCount
					self.page = 1
					if self.totalCount > self.listRepositories.count {
						self.hasNextPage = true
					}
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
