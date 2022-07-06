//
//  InvoiceHomeTableHeaderView.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-05.
//

import UIKit

class InvoiceHomeTableHeaderView: UITableViewHeaderFooterView {
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Invoice List"
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    let addButton = UIButton()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        confitureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func confitureContents(){
        
    }
}
