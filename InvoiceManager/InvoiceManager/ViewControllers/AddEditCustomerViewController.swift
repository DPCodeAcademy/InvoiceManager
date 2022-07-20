//
//  AddEditCustomerViewController.swift
//  InvoiceManager
//
//  Created by Kaiya Takahashi on 2022-07-19.
//

import UIKit

class AddEditCustomerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var nameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var baseRateTF: UITextField!
    @IBOutlet var checkBox: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var saveNextBtn: UIButton!

    var customer: Customer?
    var events = [Event]()
    
    init?(coder: NSCoder, customer: Customer) {
        super.init(coder: coder)
        self.customer = customer
        self.events = AppDataManager.shared.getEventList(customerID: customer.customerID)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customer = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.placeholder = customer?.information.customerName ?? "Name"
        emailTF.placeholder = customer?.information.eMailAddress ?? "Email Address"
        baseRateTF.placeholder = customer != nil ? "\(customer!.information.customerRate)": "Base Rate"
        saveNextBtn.setTitle(customer != nil ? "Save": "Next", for: .normal)
    }

    @IBAction func checkBoxTapped(_ sender: UIButton) {
        checkBox.isSelected.toggle()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventCollectionViewCell
        let event = events[indexPath.row]
        cell.eventNameLabel.text = event.eventName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}
