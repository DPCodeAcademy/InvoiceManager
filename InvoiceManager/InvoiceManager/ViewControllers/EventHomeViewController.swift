//
//  EventHomeViewController.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-21.
//

import UIKit

class EventHomeViewController: UIViewController {

	@IBOutlet var targetMonthInput: UITextField!
	@IBOutlet var eventHomeTableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
    
	@IBSegueAction func cellTapped(_ coder: NSCoder, sender: Any?) -> EventDetailViewController? {
		guard let cell = sender, let indexPath = eventHomeTableView.indexPath(for: cell as! UITableViewCell) else { return nil}
		return EventDetailViewController(coder: coder)
	}
}
