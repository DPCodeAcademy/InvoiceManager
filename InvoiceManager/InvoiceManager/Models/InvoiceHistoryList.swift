//
//  InvoiceHistoryList.swift
//  InvoiceManager
//
//  Created by 鈴木啓司 on 2022-06-29.
//
import Foundation

class InvoiceHistoryList{
    var invoiceHistories: Set<InvoiceHitory> = []
    
    func createNewInvoiceHistory(newInvoiceInfo: InvoiceHitory.Information) -> InvoiceHitory{
        let uniqueID = self.geranateUniqueID()
        let invoice = InvoiceHitory(id: uniqueID, info: newInvoiceInfo)
        invoiceHistories.insert(invoice)
        return invoice
    }
    
    func getInvoiceList() -> Set<InvoiceHitory>{
        return invoiceHistories
    }
    
    func getInvoice(invoiceHistoryID: UInt16)->InvoiceHitory?{
        for invoice in invoiceHistories{
            if invoice.invoiceID == invoiceHistoryID{
                return invoice
            }
        }
        return nil
    }
    
    func getInvoiceByCustomer(customerID: UInt16)-> [InvoiceHitory]{
        var ret: [InvoiceHitory] = []
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
            let dummy = InvoiceHitory(id: id, info: InvoiceHitory.Information())
            if(!invoiceHistories.contains(dummy))
            {
                return id
            }
        }while true
    }
}

struct InvoiceHitory: Hashable{
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
    
    static func == (lhs: InvoiceHitory, rhs: InvoiceHitory) -> Bool {
        return lhs.invoiceID == rhs.invoiceID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(invoiceID)
    }
    
}
