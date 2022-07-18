//
//  InvoiceHistory.swift
//  InvoiceManager
//
//  Created by Joao Victor Silva Anastacio on 2022-07-06.
//

import Foundation

struct Invoice: Hashable {

    let invoiceID: UInt16
    let customerID: UInt16
    let dateIssued: Date
    var userInfo: UserSetting = UserSetting()
    var invoiceItems: [InvoiceItem] = []

    init(invoiceID: UInt16, customerID: UInt16, dateIssued: Date) {
        self.invoiceID = invoiceID
        self.customerID = customerID
        self.dateIssued = dateIssued
    }

    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        return lhs.invoiceID == rhs.invoiceID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(invoiceID)
    }
}

struct InvoiceItem: Hashable {
    var startDateTime: Date
    var durationMinutes: Int
    var price: Int
    var eventName: String
}
