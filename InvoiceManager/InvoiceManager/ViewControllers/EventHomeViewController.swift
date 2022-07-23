//
//  EventHomeViewController.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-21.
//

import UIKit

class EventHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	let datePicker = MonthYearDatePicker()
	
	var eventList = EventType(group: [], individual: [])

	@IBOutlet var targetMonthInput: UITextField!
	@IBOutlet var eventHomeTableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		displayDatePicker()
		eventList = AppDataManager.shared.getEventOrganizedList(in: datePicker.date)
		
		eventHomeTableView.delegate = self
		eventHomeTableView.dataSource = self
		
		
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
		eventList = AppDataManager.shared.getEventOrganizedList(in: datePicker.date)

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
	
	// MARK: table view configuration

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: EventHomeTableViewCell.identifier, for: indexPath) as! EventHomeTableViewCell
//		let event = eventList[indexPath.row]
//		let eventDetail = event.eventDetails.first
//
//		cell.eventNameLabel.text = event.eventName
//		cell.horlyRateLabel.text = "$\(event.eventRate)/h"
//		cell.attendeesLabel.text = "Attendees: \(String(describing: eventDetail!.attendees.count))"
		
		return cell
	}
	
	@IBSegueAction func cellTapped(_ coder: NSCoder, sender: Any?) -> EventDetailViewController? {
		guard let cell = sender, let indexPath = eventHomeTableView.indexPath(for: cell as! UITableViewCell) else { return nil}
		return EventDetailViewController(coder: coder)
	}
}
