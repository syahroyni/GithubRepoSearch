//
//  RepositoryTableViewCell.swift
//  GithubRepositorySearch
//
//  Created by Muhammad Syah Royni on 12/09/22.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

	@IBOutlet weak var repositoryNameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var lastUpdatedLabel: UILabel!
	@IBOutlet weak var watcherCountLabel: UILabel!
	@IBOutlet weak var starCountLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setRepositoryModel(repository: RepositoryModel) {
		repositoryNameLabel.text = repository.fullName
		descriptionLabel.text = repository.description
		lastUpdatedLabel.text = "Last Updated at \(getFormattedDate(dateString: repository.lastUpdate))"
		watcherCountLabel.text = "\(repository.watchersCount)"
		starCountLabel.text = "\(repository.starsCount)"
	}
	
	func getFormattedDate(dateString: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
		if let date = dateFormatter.date(from: dateString) {
			let newDateFormatter = DateFormatter()
			newDateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
			return newDateFormatter.string(from: date)
		}
		return ""
	}

}
