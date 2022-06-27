//
//  ImportCalenderViewController.swift
//  InvoiceManager
//
//  Created by 鈴木啓司 on 2022-06-23.
//

import UIKit

class ImportCalenderViewController: UIViewController {
  
  @IBOutlet var fromField: UITextField!
  @IBOutlet var toField: UITextField!
  @IBOutlet var importButton: UIButton!
  
  var fromDate: Date?
  var toDate: Date?
  
  let datePicker = UIDatePicker()
  var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createDatePicker()
  }
  
  func createToolBar() -> UIToolbar {
    let toolBar = UIToolbar()
    toolBar.sizeToFit()

    let doneButton =  UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTapped))
    toolBar.setItems([doneButton], animated: true )

    return toolBar
  }

  func createDatePicker() {
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.datePickerMode = .date
    datePicker.minimumDate = Date.now
    
    fromField.inputView = datePicker
    fromField.text = dateFormatter.string(from: Date.now)
    fromField.inputAccessoryView = createToolBar()
    
    let aMonthLater = Date(timeInterval: 2600000, since: Date.now)
    toField.inputView = datePicker
    toField.text = dateFormatter.string(from: aMonthLater)
    toField.inputAccessoryView = createToolBar()
  }

  @objc func doneButtonTapped() {
    if fromField.isFirstResponder {
      fromDate = datePicker.date
      self.fromField.text = dateFormatter.string(from: datePicker.date)
    } else {
      toDate = datePicker.date
      self.toField.text = dateFormatter.string(from: datePicker.date)
    }
    self.view.endEditing(true)
  
    if let fromDate = fromDate, let toDate = toDate {
      if fromDate < toDate {
        importButton.isEnabled = true
      } else {
        importButton.isEnabled = false
      }
    }
    
  }

  
  @IBAction func importButtonTapped(_ sender: UIButton) {
  }
}
