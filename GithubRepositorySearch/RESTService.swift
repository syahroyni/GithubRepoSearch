//
//  RESTService.swift
//  GithubRepositorySearch
//
//  Created by Muhammad Syah Royni on 13/09/22.
//

import Foundation

class RESTService: NSObject {
	
	func fetch(url: URL, completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
		
		let dataTask = URLSession.shared.dataTask(with: url) { resultData, urlResponse, error in
			
			completion(resultData, urlResponse, error)
		}

		dataTask.resume()
	}
	
}
