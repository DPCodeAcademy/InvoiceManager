//
//  InvoiceHomeTableHeaderView.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-07-05.
//

import UIKit

class InvoiceHomeTableHeaderView: UITableViewHeaderFooterView {
	
	static let identifier = "invoiceTableViewSectionHeader"
    
    var title: UILabel = {
        let label = UILabel()
        label.text = "Invoice List"
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
	let addButton: UIButton = {
		let button = UIButton(type: .system)
		button.addTarget(self, action: #selector(addInvoiceTapped), for: .touchUpInside)
		button.setImage(UIImage(systemName: "plus"), for: .normal)
		return button
	}()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        confitureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func confitureContents(){
		title.translatesAutoresizingMaskIntoConstraints = false
		addButton.translatesAutoresizingMaskIntoConstraints = false
		
        addSubview(title)
		addSubview(addButton)
		
		NSLayoutConstraint.activate([
			title.topAnchor.constraint(equalTo: contentView.topAnchor),
			title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			title.widthAnchor.constraint(equalToConstant: 100),
			title.heightAnchor.constraint(equalToConstant: 20),
			addButton.widthAnchor.constraint(equalToConstant: 20),
			addButton.heightAnchor.constraint(equalToConstant: 20),
			addButton.topAnchor.constraint(equalTo: contentView.topAnchor),
			addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
		])
    }
	
	@objc func addInvoiceTapped(){
		print("let's add new invoice")
	}
}
