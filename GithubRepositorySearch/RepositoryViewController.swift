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
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	var timer: Timer?
	var isFirstTime = true
	var isLoading = false
	
	var viewModel: RepositoryViewModel = RepositoryViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		repositoriesTableView.dataSource = self
		repositoriesTableView.delegate = self
		observeViewModel()
		searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
	}
	
	func observeViewModel() {
		viewModel.needToReloadData = {[weak self] in
			DispatchQueue.main.async {
				self?.activityIndicator.stopAnimating()
				self?.isLoading = false
				self?.repositoriesTableView.reloadData()
			}
		}
		
		viewModel.onNeedToShowAlert = {[weak self] title, message in
			DispatchQueue.main.async {
				self?.activityIndicator.stopAnimating()
				self?.isLoading = false
				let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				self?.present(alert, animated: true, completion: nil)
			}
		}
	}
	
	@objc func textFieldDidChange(textField: UITextField) {
		isFirstTime = false
		timer?.invalidate()
		timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.searchText), userInfo: nil, repeats: false)
	}
	
	@objc func searchText() {
		if (searchTextField.text == nil || searchTextField.text == "") {
			isLoading = false
			activityIndicator.stopAnimating()
			return
		}
		activityIndicator.startAnimating()
		isLoading = true
		repositoriesTableView.reloadData()
		viewModel.searchingText = searchTextField.text ?? ""
	}

}
extension RepositoryViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if isLoading {

			tableView.setEmptyMessage("Looking for Github Repository")
			return 0
		}
		if viewModel.listRepositories.count == 0 {
			var message: String = ""
			if isFirstTime {
				message = "Looking for Github Repository?"
			} else {
				message = "We can't find the Repository"
			}
			
			tableView.setEmptyMessage(message)
		} else {
			tableView.restore()
		}
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
extension RepositoryViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row >= viewModel.listRepositories.count - 2 {
			viewModel.loadNextPage()
		}
	}
}
extension UITableView {

	func setEmptyMessage(_ message: String) {
		let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
		messageLabel.text = message
		messageLabel.textColor = .black
		messageLabel.numberOfLines = 0
		messageLabel.textAlignment = .center
		messageLabel.sizeToFit()

		self.backgroundView = messageLabel
		self.separatorStyle = .none
	}

	func restore() {
		self.backgroundView = nil
		self.separatorStyle = .singleLine
	}
}

