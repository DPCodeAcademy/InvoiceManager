//
//  InvoiceHistoryList.swift
//  InvoiceManager
//
//  Created by 鈴木啓司 on 2022-06-29.
//

import Foundation

class InvoiceHistoryViewModel {

	var invoiceHistories: Set<Invoice> = []

	func addInvoiceHistory(invoice: Invoice) {
		if let oldInvoice = getInvoice(customerID: invoice.customerID, month: invoice.dateIssued.getMonth(), year: invoice.dateIssued.getYear()) {
			invoiceHistories.remove(oldInvoice)
		}
		invoiceHistories.insert(invoice)
	}

	func getInvoice(customerID: UInt16, month: Month, year: Int ) -> Invoice? {
		for invoice in invoiceHistories where invoice.dateIssued.getMonth() == month && invoice.dateIssued.getYear() == year {
			return invoice
		}
		return nil
	}

	func getInvoice(invoiceHistoryID: UInt16) -> Invoice? {
		for invoice in invoiceHistories where invoice.invoiceID == invoiceHistoryID {
			return invoice
		}
		return nil
	}

	func getInvoiceByCustomer(customerID: UInt16) -> [Invoice] {
		var ret: [Invoice] = []
		for history in invoiceHistories where history.customerID == customerID {
			ret.append(history)
		}
		ret.sort {
			$0.dateIssued < $1.dateIssued
		}
		return ret
	}

	func hasInvoiceHistory(customerID: UInt16, month: Month, year: Int ) -> Bool {
		return getInvoice(customerID: customerID, month: month, year: year) != nil
	}

	func createNewInvoiceHistory(customerID: UInt16, dateIssued: Date) -> Invoice {
		let uniqueID = self.geranateUniqueID()
		let invoice = Invoice(invoiceID: uniqueID, customerID: customerID, dateIssued: dateIssued)
		return invoice
	}

	func removeInvoiceHistory(customerID: UInt16) {
		let invoiceList = getInvoiceByCustomer(customerID: customerID)
		for invoice in invoiceList {
			invoiceHistories.remove(invoice)
		}
	}

	func updateInvoiceHistory(invoice: Invoice) -> Bool {
		if invoiceHistories.update(with: invoice) != nil {
			return true
		}
		return false
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
