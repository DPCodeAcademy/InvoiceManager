//
//  EventHomeViewController.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-21.
//

import UIKit

class EventHomeViewController: UIViewController {
	
	let datePicker = MonthYearDatePicker()

	@IBOutlet var targetMonthInput: UITextField!
	@IBOutlet var eventHomeTableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		displayDatePicker()
    }
	
	// MARK: Custom date picker configration
	func createToolBar() -> UIToolbar {
		let toolBar = UIToolbar()
		toolBar.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(finishDatePick))
		toolBar.setItems([doneButton], animated: true)
		return toolBar
	}
	
	@objc func finishDatePick () {
		targetMonthInput.text = convertDateToString(from: datePicker.date)

		self.eventHomeTableView.reloadData()
		self.view.endEditing(true)
	}
	
	func createDatePicker ( ) -> MonthYearDatePicker {
		datePicker.minYear = 2000
		datePicker.maxYear = 2050
		datePicker.rowHeight = 60
		
		datePicker.selectRow(datePicker.todayIndexPath.section, inComponent: 1, animated: false)
		datePicker.selectRow(datePicker.todayIndexPath.row, inComponent: 0, animated: false)

		return datePicker
	}
	
	func displayDatePicker ( ) {
		let datePicker = createDatePicker()
		targetMonthInput.text = convertDateToString(from: datePicker.date)
		targetMonthInput.inputView = datePicker
		targetMonthInput.inputAccessoryView = createToolBar()
	}
	
	func convertDateToString(from date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM,yyyy"
		let dateText = formatter.string(from: date)
		return dateText
	}
    
	@IBSegueAction func cellTapped(_ coder: NSCoder, sender: Any?) -> EventDetailViewController? {
		guard let cell = sender, let indexPath = eventHomeTableView.indexPath(for: cell as! UITableViewCell) else { return nil}
		return EventDetailViewController(coder: coder)
	}
}
