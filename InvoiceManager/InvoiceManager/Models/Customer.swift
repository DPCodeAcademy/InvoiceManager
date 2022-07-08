//
//  Customer.swift
//  InvoiceManager
//
//  Created by Joao Victor Silva Anastacio on 2022-07-06.
//

import Foundation

struct Customer: Hashable {

    let customerID: UInt16
    var information: CustomerInformation

    init(id: UInt16, info: CustomerInformation) {
        self.customerID = id
        self.information = info
    }

    func getInformation() -> CustomerInformation {
        return self.information
    }

    mutating func updateInformation(info: CustomerInformation) {
        self.information = info
    }

    static func == (lhs: Customer, rhs: Customer) -> Bool {
        return lhs.customerID == rhs.customerID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(customerID)
    }
}

struct CustomerInformation {
    var customerName: String = ""
    var eMailAddress: String = ""
    var isAutoSendInvoice: Bool = true
    var customerRate: Int = 0
}
