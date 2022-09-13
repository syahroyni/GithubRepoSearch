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
	
	var timer: Timer?
	
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
		
		viewModel.onNeedToShowAlert = {[weak self] title, message in
			DispatchQueue.main.async {
				let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				self?.present(alert, animated: true, completion: nil)
			}
		}
	}
	
	@objc func textFieldDidChange(textField: UITextField) {
			
		timer?.invalidate()
		timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.searchText), userInfo: nil, repeats: false)
	}
	
	@objc func searchText() {
		
		viewModel.searchingText = searchTextField.text ?? ""
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

