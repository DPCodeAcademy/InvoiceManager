//
//  InvoiceHomeViewController.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-05.
//

import UIKit

class InvoiceHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var invoiceHistoryList = AppDataManager.shared.getInvoiceHistoryList()
	var customerList = Array(AppDataManager.shared.getCustomerList())

	let datePicker = MonthYearDatePicker()
	var invoicesInTargetPriod: [InvoiceHitory] = []

    @IBOutlet var targetMonthInputField: UITextField!
    @IBOutlet var invoiceListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.viewControllers = [self]
		displayDatePicker()

        invoiceListTableView.delegate = self
        invoiceListTableView.dataSource = self
    }

	func filterInvoiceHistroy(by date: Date) {
		guard !invoiceHistoryList.isEmpty else {
			invoicesInTargetPriod = []
			return
		}
		let targetYearInvoices = invoiceHistoryList.filter { Calendar.current.isDate($0.information.dateIssued, equalTo: date, toGranularity: .year)}
		invoicesInTargetPriod = targetYearInvoices.filter { Calendar.current.isDate($0.information.dateIssued, equalTo: date, toGranularity: .month)}
	}

// MARK: Custom date picker confituration
	func createToolBar() -> UIToolbar {
		let toolBar = UIToolbar()
		toolBar.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(finishDatePick))
		toolBar.setItems([doneButton], animated: true)
		return toolBar
	}

	@objc func finishDatePick () {
		targetMonthInputField.text = convertDateToString(from: datePicker.date)
		filterInvoiceHistroy(by: datePicker.date)

		self.invoiceListTableView.reloadData()
		self.view.endEditing(true)
	}

	func createDatePicker( ) -> MonthYearDatePicker {
		datePicker.minYear = 2000
		datePicker.maxYear = 2050
		datePicker.rowHeight = 60

		datePicker.selectRow(datePicker.todayIndexPath.section, inComponent: 1, animated: false)
		datePicker.selectRow(datePicker.todayIndexPath.row, inComponent: 0, animated: false)

		return datePicker
	}

	func displayDatePicker ( ) {
		let datePicker = createDatePicker()
		targetMonthInputField.text = convertDateToString(from: datePicker.date)
		targetMonthInputField.inputView = datePicker
		targetMonthInputField.inputAccessoryView = createToolBar()

		filterInvoiceHistroy(by: datePicker.date)
	}

	func convertDateToString(from date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM,yyyy"
		let dateText = formatter.string(from: date)
		return dateText
	}

// MARK: Table view confituration
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return customerList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InvoiceHomeTableViewCell.identifier, for: indexPath) as! InvoiceHomeTableViewCell
		let customer: Customer = customerList[indexPath.row]
		cell.customerNameLabel.text = customer.information.customerName
		cell.customerEmailLabel.text = customer.information.eMailAddress
		cell.invoiceStatusLabel.text = checkInvoices(for: customer) ? "Sent" : "Not Sent"

        return cell
    }

	func checkInvoices(for customer: Customer) -> Bool {
		guard !invoicesInTargetPriod.isEmpty else { return false }
		let index = invoicesInTargetPriod.firstIndex { $0.information.customerID == customer.customerID }
		if index == nil {
			return false
		} else {
			return true
		}
	}
}
