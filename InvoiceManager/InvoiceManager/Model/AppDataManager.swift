//
//  AppDataManager.swift
//  InvoiceManager
//
//  Created by 鈴木啓司 on 2022-06-29.
//

import Foundation

class AppDataManager{
  
  static let shared = AppDataManager()
  
  private var customerList : CustomerList
  private var eventList : EventList
  private var invoiceHistoryList : InvoiceHistoryList
  private var userSetting : UserSetting
  
  private init() {
    customerList = CustomerList()
    eventList = EventList()
    invoiceHistoryList = InvoiceHistoryList()
    userSetting = UserSetting()
  }
  
  func restoreData() -> Void{
    // Restore all data from iPhone local storage
    setSampleData()
    
    print(customerList.getCustomerList())
    print(eventList.getEventList())
    print(userSetting)
  }
  
  private func storeData() -> Void{
    // Store all data into iPhone local storage
    // Call this method every time user changes information.
    
  }
  
  //------------------------------------------------------
  // Temporary methods. These methods should be deleted.
  private func setSampleData() -> Void{
    setSampleCustomer()
    setSampleEvent()
    setSampleUserSetting()
    setSampleInvoiceHistory()
  }
  
  private var c1: UInt16 = 0
  private var c2: UInt16 = 0
  private var c3: UInt16 = 0
  private var c4: UInt16 = 0
  private var c5: UInt16 = 0
  private var c6: UInt16 = 0
  
  private func setSampleCustomer()->Void{
    c1 = customerList.createNewCustomer(newCustomerInfo: Customer.Information(customerName: "João Victor Anastácio", eMailAddress: "aaa@gmail.com", isAutoSendInvoice: true, customerRate: 101)).customerID
    c2 = customerList.createNewCustomer(newCustomerInfo: Customer.Information(customerName: "Kaiya Takahashi", eMailAddress: "bbb@gmail.com", isAutoSendInvoice: true, customerRate: 102)).customerID
    c3 = customerList.createNewCustomer(newCustomerInfo: Customer.Information(customerName: "Keiji Suzuki", eMailAddress: "ccc@gmail.com", isAutoSendInvoice: true, customerRate: 103)).customerID
    c4 = customerList.createNewCustomer(newCustomerInfo: Customer.Information(customerName: "Tomonao Hashiguchi", eMailAddress: "ddd@gmail.com", isAutoSendInvoice: true, customerRate: 104)).customerID
    c5 = customerList.createNewCustomer(newCustomerInfo: Customer.Information(customerName: "Yusuke Ishihara", eMailAddress: "eee@gmail.com", isAutoSendInvoice: true, customerRate: 105)).customerID
    c6 = customerList.createNewCustomer(newCustomerInfo: Customer.Information(customerName: "Yusuke Kohatsu", eMailAddress: "fff@gmail.com", isAutoSendInvoice: true, customerRate: 101)).customerID
  }
  
  private func setSampleEvent()->Void{
    var event1 = Event(eventName: "Programing class", eventRate: 100, eventDetails: [])
    event1.eventDetails.append(EventDetail(startDateTime: Date(timeIntervalSinceNow: TimeInterval(1)), endDateTime: Date(timeIntervalSince1970: TimeInterval(2)), attendees: [c1, c2, c3, c4, c5, c6]))

    event1.eventDetails.append(EventDetail(startDateTime: Date(timeIntervalSinceNow: TimeInterval(3)), endDateTime: Date(timeIntervalSinceNow: TimeInterval(4)), attendees: [c1, c3, c5]))
    
    event1.eventDetails.append(EventDetail(startDateTime: Date(timeIntervalSinceNow: TimeInterval(5)), endDateTime: Date(timeIntervalSinceNow: TimeInterval(5)), attendees: [c2, c4, c6]))
    
    var event2 = Event(eventName: "João Victor Anastácio", eventRate: 100, eventDetails: [])
    event2.eventDetails.append(EventDetail(startDateTime: Date(timeIntervalSinceNow: TimeInterval(100)), endDateTime: Date(timeIntervalSinceNow: TimeInterval(101)), attendees: [c1]))

    var event3 = Event(eventName: "Yoko Ono", eventRate: 50, eventDetails: [])
    event3.eventDetails.append(EventDetail(startDateTime: Date(timeIntervalSince1970: TimeInterval(1002)), endDateTime: Date(timeIntervalSince1970: TimeInterval(1003)), attendees: []))

    eventList.addAndUpdateEvent(event: event1)
    eventList.addAndUpdateEvent(event: event2)
    eventList.addAndUpdateEvent(event: event3)
  }
  
  private func setSampleUserSetting()->Void{
    userSetting.companyAddress = "628-68 Smithe ST/nVancouver, BC V6B 0P4"
    userSetting.companyName = "DP Code Academy"
    userSetting.paymentMethod = "E-transfer"
  }
  
  private func setSampleInvoiceHistory()->Void{
    
  }
}
