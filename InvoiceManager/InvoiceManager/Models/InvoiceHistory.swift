//
//  InvoiceHistory.swift
//  InvoiceManager
//
//  Created by Joao Victor Silva Anastacio on 2022-07-06.
//

import Foundation

struct InvoiceHitory: Hashable {

    let invoiceID: UInt16
    var information: InvoiceHistoryInformation

    init(id: UInt16, info: InvoiceHistoryInformation) {
        self.invoiceID = id
        self.information = info
    }

    static func == (lhs: InvoiceHitory, rhs: InvoiceHitory) -> Bool {
        return lhs.invoiceID == rhs.invoiceID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(invoiceID)
    }
}

struct InvoiceHistoryInformation {
    var customerID: UInt16 = 0
    var eventList: Set<Event> = []
    var dateIssued: Date = Date()
}
