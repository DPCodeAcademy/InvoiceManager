//
//  CustomerHomeViewController.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-05.
//

import UIKit

class CustomerHomeViewController: UIViewController {

    @IBOutlet var customerListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        customerListTableView.delegate = self
//        customerListTableView.dataSource = self
//        customerListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "customerTableCell")
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    
    @IBAction func importCalenderButtonTapped() {
    }
    
}
