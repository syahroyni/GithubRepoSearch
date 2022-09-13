//
//  ViewController.swift
//  GithubRepositorySearch
//
//  Created by Muhammad Syah Royni on 12/09/22.
//

import UIKit

class RepositoryViewController: UIViewController {

	@IBOutlet weak var searchTextField: UITextField!
	@IBOutlet weak var repositoriesTableView: UITableView!
	
	var viewModel: RepositoryViewModel = RepositoryViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		repositoriesTableView.dataSource = self
		observeViewModel()
		searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
	}
	
	func observeViewModel() {
		viewModel.needToReloadData = {[weak self] in
			DispatchQueue.main.async {
				self?.repositoriesTableView.reloadData()
			}
		}
	}
	
	@objc func textFieldDidChange(textField: UITextField) {
			
		viewModel.searchingText = textField.text ?? ""
	}

}
extension RepositoryViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return viewModel.listRepositories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell") as? RepositoryTableViewCell {
			
			let repositoryModel = viewModel.listRepositories[indexPath.row]
			cell.setRepositoryModel(repository: repositoryModel)
			
			return cell
		}
		
		return UITableViewCell()
	}
}

