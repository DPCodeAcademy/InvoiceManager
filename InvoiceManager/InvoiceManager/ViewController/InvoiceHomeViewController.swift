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
	
        invoiceListTableView.delegate = self
        invoiceListTableView.dataSource = self
//        invoiceListTableView.register(InvoiceHomeTableViewCell.self, forCellReuseIdentifier: InvoiceHomeTableViewCell.identifier)
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
    
    @IBAction func TargetMonthInputTapped(_ sender: UITextField) {
    }
    
}
