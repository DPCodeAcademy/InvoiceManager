//
//  InvoiceHistoryList.swift
//  InvoiceManager
//
//  Created by 鈴木啓司 on 2022-06-29.
//

import Foundation

class InvoiceHistoryList{
    var invoiceHistories: Set<InvoiceHistory> = []
    
    func createNewInvoiceHistory(newInvoiceInfo: InvoiceHistory.Information) -> InvoiceHistory{
        let uniqueID = self.geranateUniqueID()
        let invoice = InvoiceHistory(id: uniqueID, info: newInvoiceInfo)
        invoiceHistories.insert(invoice)
        return invoice
    }
    
    func getInvoiceList() -> Set<InvoiceHistory>{
        return invoiceHistories
    }
    
    func getInvoice(invoiceHistoryID: UInt16)->InvoiceHistory?{
        for invoice in invoiceHistories{
            if invoice.invoiceID == invoiceHistoryID{
                return invoice
            }
        }
        return nil
    }
    
    func getInvoiceByCustomer(customerID: UInt16)-> [InvoiceHistory]{
        var ret: [InvoiceHistory] = []
        for history in invoiceHistories{
            if history.information.customerID == customerID{
                ret.append(history)
            }
        }
        ret.sort {
            $0.information.dateIssued < $1.information.dateIssued
        }
        return ret
    }
    
    func removeInvoiceHistory(customerID: UInt16)->Void{
        let invoiceList = getInvoiceByCustomer(customerID: customerID)
        for invoice in invoiceList{
            invoiceHistories.remove(invoice)
        }
    }
    
    private func geranateUniqueID()-> UInt16{
        repeat{
            let id = UInt16.random(in: 1...UInt16.max)
            let dummy = InvoiceHistory(id: id, info: InvoiceHistory.Information())
            if(!invoiceHistories.contains(dummy))
            {
                return id
            }
        }while true
    }
}

struct InvoiceHistory: Hashable{ // spelling error
    let invoiceID: UInt16
    var information: Information
    
    struct Information{
        var customerID: UInt16 = 0
        var eventList: Set<Event> = []
        var dateIssued: Date = Date()
    }
    
    init(id: UInt16, info: Information){
        self.invoiceID = id
        self.information = info
    }
    
    static func == (lhs: InvoiceHistory, rhs: InvoiceHistory) -> Bool {
        return lhs.invoiceID == rhs.invoiceID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(invoiceID)
    }
    
}
