//
//  InvoiceHistoryList.swift
//  InvoiceManager
//
//  Created by 鈴木啓司 on 2022-06-29.
//

import Foundation

class InvoiceHistoryViewModel {

    var invoiceHistories: Set<InvoiceHitory> = []

    func createNewInvoiceHistory(newInvoiceInfo: InvoiceHistoryInformation) -> InvoiceHitory {
        let uniqueID = self.geranateUniqueID()
        let invoice = InvoiceHitory(id: uniqueID, info: newInvoiceInfo)
        invoiceHistories.insert(invoice)
        return invoice
    }

    func getInvoiceList() -> Set<InvoiceHitory> {
        return invoiceHistories
    }

    func getInvoice(invoiceHistoryID: UInt16) -> InvoiceHitory? {
        for invoice in invoiceHistories where invoice.invoiceID == invoiceHistoryID {
			return invoice
        }
        return nil
    }

    func getInvoiceByCustomer(customerID: UInt16) -> [InvoiceHitory] {
        var ret: [InvoiceHitory] = []
        for history in invoiceHistories where history.information.customerID == customerID {
			ret.append(history)
        }
        ret.sort {
            $0.information.dateIssued < $1.information.dateIssued
        }
        return ret
    }

    func removeInvoiceHistory(customerID: UInt16) {
        let invoiceList = getInvoiceByCustomer(customerID: customerID)
        for invoice in invoiceList {
            invoiceHistories.remove(invoice)
        }
    }

    private func geranateUniqueID() -> UInt16 {
        repeat {
            let id = UInt16.random(in: 1...UInt16.max)
			var isExistID = false
			for history in invoiceHistories where history.invoiceID == id {
				isExistID = true
				break
			}
			if !isExistID {
				return id
			}
        }while true
    }
}
