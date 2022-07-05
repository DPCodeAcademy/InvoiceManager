//
//  CalenderEventsCollectionViewCell.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-06-28.
//

import UIKit

protocol EventDetailPopupDelegate{
    func detailButtonTapped(show alertView: UIAlertController)
}

class CalenderEventsCollectionViewCell: UICollectionViewCell {
    
    var delegate: EventDetailPopupDelegate?
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    var evnetName: String!
    var attendees: String = "N/A"
    
    @IBAction func detailButtonTapped(_ sender: UIButton) {
        let message = "\nDate\n\(self.dateLabel.text!) \n\nTime\n \(self.timeLabel.text!)\n\nAttendees\n\(self.attendees)"
        let alert = UIAlertController(title: self.evnetName, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        delegate?.detailButtonTapped(show: alert)
        
    }
}
