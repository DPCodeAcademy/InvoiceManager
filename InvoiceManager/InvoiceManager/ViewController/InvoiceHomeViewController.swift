//
//  InvoiceHomeViewController.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-05.
//

import UIKit

class InvoiceHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    var invoiceHistoryList = AppDataManager.shared.getInvoiceHistoryList()
	var customerList = Array(AppDataManager.shared.getCustomerList())
	var targetPriod = Date()
	
	let datePicker = MonthYearDatePicker()
    
    @IBOutlet var targetMonthInputField: UITextField!
    @IBOutlet var invoiceListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		displayDatePicker()
	
        invoiceListTableView.delegate = self
        invoiceListTableView.dataSource = self
	}
	
//	func filterInvoiceHistroy(by date: Date) ->  Set<InvoiceHistoryList{
//		guard !invoiceHistoryList.isEmpty else {return []}
//		let targetMonthInvoices = invoiceHistoryList.filter { Calendar.current.isDate($0.information.dateIssued, equalTo: date, toGranularity: .month)}
//
//		return targetMonthInvoices
//	}
	
// Date Picker configuration
	func createToolBar() -> UIToolbar {
		let toolBar = UIToolbar()
		toolBar.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(finishDatePick))
		toolBar.setItems([doneButton], animated: true)
		return toolBar
	}
	
	@objc func finishDatePick(){
		targetMonthInputField.text = convertDateToString(from: datePicker.date)
		targetPriod = datePicker.date
		
		self.invoiceListTableView.reloadData()
		self.view.endEditing(true)
	}
	
	func createDatePicker() -> MonthYearDatePicker {
		datePicker.minYear = 2000
		datePicker.maxYear = 2050
		datePicker.rowHeight = 60
		
		datePicker.selectRow(datePicker.todayIndexPath.section, inComponent: 1, animated: false)
		datePicker.selectRow(datePicker.todayIndexPath.row, inComponent: 0, animated: false)

		return datePicker
	}
	
	func displayDatePicker(){
		let datePicker = createDatePicker()
		targetMonthInputField.text = convertDateToString(from: datePicker.date)
		targetMonthInputField.inputView = datePicker
		targetMonthInputField.inputAccessoryView = createToolBar()
	}
	
	func convertDateToString(from date:Date) -> String{
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM,yyyy"
		let dateText = formatter.string(from: date)
		return dateText
	}
    
// Table view configuration
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
        cell.invoiceStatusLabel.text = "Sent"
        
        return cell
    }
}
