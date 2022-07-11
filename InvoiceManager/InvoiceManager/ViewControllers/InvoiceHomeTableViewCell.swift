//
//  InvoiceHomeTableViewCell.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-05.
//

import UIKit

class InvoiceHomeTableViewCell: UITableViewCell {
    
    static let identifier = "invoiceHomeTableCell"
    
    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var customerEmailLabel: UILabel!
    @IBOutlet var invoiceStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
