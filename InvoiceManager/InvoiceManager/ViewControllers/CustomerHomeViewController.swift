//
//  CustomerHomeViewController.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-05.
//

import UIKit

class CustomerHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var customerList = Array(AppDataManager.shared.getCustomerList())

    @IBOutlet var customerListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = "Customer"
		
		customerListTableView.delegate = self
		customerListTableView.dataSource = self
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return customerList.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "customerListCell", for: indexPath)
		let customer = customerList[indexPath.row]
		cell.textLabel?.text = customer.information.customerName
		cell.detailTextLabel?.text = customer.information.eMailAddress
		return cell
	}

    @IBAction func importCalenderButtonTapped() {
    }
    
    @IBSegueAction func cellTapped(_ coder: NSCoder, sender: UITableViewCell?) -> AddEditCustomerViewController? {
        guard let cell = sender, let indexPath = customerListTableView.indexPath(for: cell) else { return nil }
        let customer = customerList[indexPath.row]
        return AddEditCustomerViewController(coder: coder, customer: customer)
    }
    
}
