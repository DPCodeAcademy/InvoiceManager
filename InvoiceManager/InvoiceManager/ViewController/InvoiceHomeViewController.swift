//
//  InvoiceHomeViewController.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-05.
//

import UIKit

class InvoiceHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    var invoiceList = AppDataManager.shared.getInvoiceHistoryList()
	var customerList = Array(AppDataManager.shared.getCustomerList())
	var targetPriod = Date()
    
    @IBOutlet var targetMonthInputField: UITextField!
    @IBOutlet var invoiceListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		displayDatePicker()
	
        invoiceListTableView.delegate = self
        invoiceListTableView.dataSource = self
//        invoiceListTableView.register(InvoiceHomeTableViewCell.self, forCellReuseIdentifier: InvoiceHomeTableViewCell.identifier)
	}
	
	func createToolBar() -> UIToolbar {
		let toolBar = UIToolbar()
		toolBar.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(finishDatePick))
		toolBar.setItems([doneButton], animated: true)
		return toolBar
	}
	
	@objc func finishDatePick(){
		
	}
	
	func createDatePicker() -> MonthYearDatePicker {
		let datePicker = MonthYearDatePicker()
		datePicker.minYear = 2000
		datePicker.maxYear = 2050
		datePicker.rowHeight = 60
		
		datePicker.selectRow(datePicker.todayIndexPath.section, inComponent: 1, animated: false)
		datePicker.selectRow(datePicker.todayIndexPath.row, inComponent: 0, animated: false)

		return datePicker
	}
	
	func displayDatePicker(){
		let datePicker = createDatePicker()
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM,yyyy"
		print(datePicker.date)
		let inputText = formatter.string(from: datePicker.date)
		targetMonthInputField.text = inputText
		targetMonthInputField.inputView = datePicker
		targetMonthInputField.inputAccessoryView = createToolBar()
	}
    
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
        cell.invoiceStatusLabel.text = "send"
        
        return cell
    }

}
