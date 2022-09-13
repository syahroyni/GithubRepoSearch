//
//  RepositoryViewModel.swift
//  GithubRepositorySearch
//
//  Created by Muhammad Syah Royni on 13/09/22.
//

import Foundation

class RepositoryViewModel: NSObject {
	
	public var searchingText: String = ""
	public var listRepositories: [RepositoryModel] = []
	
	private let githubFacade: GithubFacade
	private var searchedText: String = ""
	private var isSearching: Bool = false
	
	init(githubFacade: GithubFacade = GithubService()) {
		self.githubFacade = githubFacade
		super.init()
	}
}
