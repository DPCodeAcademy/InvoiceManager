//
//  AddEditCustomerViewController.swift
//  InvoiceManager
//
//  Created by Kaiya Takahashi on 2022-07-19.
//

import UIKit

class AddEditCustomerViewController: UIViewController {

    @IBOutlet var nameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var baseRateTF: UITextField!
    @IBOutlet var checkBox: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var saveNextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        checkBox.isSelected.toggle()
    }
    
}
