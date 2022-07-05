//
//  CustomerPreviewViewController.swift
//  InvoiceManager
//
//  Created by Kaiya Takahashi on 2022-07-05.
//

import UIKit

class CustomerPreviewViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var companyLogo: UIImageView!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var companyAdressLabel: UILabel!
    @IBOutlet var paymentMethodLabel: UILabel!
    @IBOutlet var companyEmailLabel: UILabel!
    @IBOutlet var invoiceIDLabel: UILabel!
    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var customerEmailLabel: UILabel!
    @IBOutlet var itemCollectionView: UICollectionView!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var PDFBtn: UIButton!
    @IBOutlet var statusLabel: UILabel!
    
    var date: Date?
    var customer: Customer?
    var invoiceHistory: InvoiceHistory?
    var userSetting: UserSetting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let month: String
        if let date = date {
            month = dateFormatter.string(from: date)
        } else {
            month = "nil"
        }
        let customerName = customer?.information.customerName ?? "No Data"
        titleLabel.text = "\(customerName)'s Invoice in \(month)"
        companyLogo.image = userSetting?.logoImage ?? UIImage(systemName: "person")
        companyNameLabel.text = userSetting?.companyName ?? "No Data"
        companyAdressLabel.text = userSetting?.companyAddress ?? "No Data" // Need to modify format
        paymentMethodLabel.text = userSetting?.paymentMethod ?? "No Data"
        companyEmailLabel.text = userSetting?.companyEmail ?? "No Data"
        
        invoiceIDLabel.text = "\(customer?.customerID)"
        customerNameLabel.text = customerName
        customerEmailLabel.text = customer?.information.eMailAddress ?? "No Data"
    }
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func PDFBtnTapped(_ sender: UIButton) {
    }

}
