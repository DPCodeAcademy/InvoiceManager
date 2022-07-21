//
//  EventDetailViewController.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-21.
//

import UIKit

class EventDetailViewController: UIViewController {

	
	@IBOutlet var eventNameInput: UITextField!
	@IBOutlet var eventRateInput: UITextField!
	@IBOutlet var eventDetailTabelView: UITableView!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
	@IBSegueAction func cellTapped(_ coder: NSCoder, sender: Any?) -> EventEditViewController? {
		guard let cell = sender, let indexPath = eventDetailTabelView.indexPath(for: cell as! UITableViewCell) else { return nil }
		return EventEditViewController(coder: coder)
	}
}
