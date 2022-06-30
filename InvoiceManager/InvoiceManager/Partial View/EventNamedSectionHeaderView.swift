//
//  EventNamedSectionHeaderView.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-06-28.
//

import UIKit

class EventNamedSectionHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "section-header"
        
    let checkboxButton: CheckboxButton = CheckboxButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    let eventNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let holizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTopBorder(){
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 2.0)
        topBorder.backgroundColor = UIColor.black.cgColor
        self.layer.addSublayer(topBorder)
    }
    
    private func setupView(){
        holizontalStackView.addArrangedSubview(checkboxButton)
        holizontalStackView.addArrangedSubview(eventNameLabel)
        
        addSubview(holizontalStackView)
        addSubview(checkboxButton)
        addTopBorder()
    }
}
