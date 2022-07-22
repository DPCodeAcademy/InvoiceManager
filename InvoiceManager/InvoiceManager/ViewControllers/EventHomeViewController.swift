//
//  EventHomeViewController.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-21.
//

import UIKit

class EventHomeViewController: UIViewController {
	
	let datePicker = MonthYearDatePicker()
	
	var eventList = Array(AppDataManager.shared.getEventList())
	var test: [Event] = []

	@IBOutlet var targetMonthInput: UITextField!
	@IBOutlet var eventHomeTableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		displayDatePicker()
		
		testFunc(in: datePicker.date)
		print(test)
		
    }
	
	func testFunc(in priod: Date) {
		for var event in eventList {
			let newDetails = event.eventDetails.filter { NSCalendar.current.isDate($0.startDateTime, equalTo: priod, toGranularity: .year) && NSCalendar.current.isDate($0.startDateTime, equalTo: priod, toGranularity: .month)}
			if newDetails.count != 0 {
				event.eventDetails = newDetails
				test.append(event)
			}
		}
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
