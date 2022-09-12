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

}
