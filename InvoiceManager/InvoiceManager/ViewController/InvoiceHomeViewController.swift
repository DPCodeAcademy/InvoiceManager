//
//  InvoiceHomeViewController.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-05.
//

import UIKit

class InvoiceHomeViewController: UIViewController {
    
    @IBOutlet var targetMonthInputField: UITextField!
    @IBOutlet var InvoiceListTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func TargetMonthInputTapped(_ sender: UITextField) {
    }
    
}
