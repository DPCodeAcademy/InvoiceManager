//
//  EventHomeTableViewCell.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-22.
//

import UIKit

class EventHomeTableViewCell: UITableViewCell {
	
	static let identifier = "eventHomeTableCell"

	@IBOutlet var eventNameLabel: UILabel!
	@IBOutlet var attendeesLabel: UILabel!
	@IBOutlet var horlyRateLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
