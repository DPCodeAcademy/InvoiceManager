//
//  EventNamedSectionHeaderView.swift
//  InvoiceManager
//
//  Created by Tomonao Hashiguchi on 2022-06-28.
//

import UIKit

protocol EventSelectBoxDelegate: AnyObject{
    func checkmarkTapped(on eventName: String)
}

class EventNamedSectionHeaderView: UICollectionReusableView {
    
    weak var delegate: EventSelectBoxDelegate?
    
    static let reuseIdentifier = "section-header"
    static let marginTop = 10
        
    let checkboxButton: CheckboxButton = {
        let checkbox = CheckboxButton(frame: CGRect(x: 0, y: marginTop, width: 20, height: 20))
        checkbox.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        return checkbox
    }()
   
    let eventNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.frame = CGRect(x: 30, y: marginTop, width: 100, height: 20)
        return label
    }()
    
    var eventName:String = "" {
        willSet{
            eventNameLabel.text = newValue
        }
    }
    
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

        addSubview(checkboxButton)
        addSubview(eventNameLabel)
        addTopBorder()
    }
    
    @objc func checkboxTapped(){
        delegate?.checkmarkTapped(on: self.eventName)
    }
}
