//
//  InvoiceHistoryList.swift
//  InvoiceManager
//
//  Created by 鈴木啓司 on 2022-06-29.
//

import Foundation
import PDFKit
import SwiftSoup

class InvoiceHistoryViewModel {
    
    enum HTMLFileError: Error {
        case runtimeError(String)
    }
    
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
    
    func getHTMLString(for invoice: Invoice) -> String {
        var htmlString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        do {
            guard let filePath = Bundle.main.path(forResource: "invoice_template", ofType: "html") else {
                throw HTMLFileError.runtimeError("Path for the template file is invalid.")
            }
            let template = try String(contentsOfFile: filePath, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(template)
            
            // target tags for interpolation
            let logoTag = try doc.getElementById("company-image")
            let invoiceIdTag = try doc.getElementById("invoice-id")
            let issueDateTag = try doc.getElementById("date-issued")
            let companyInfoTag = try doc.getElementById("company-information")
            let customerInfoTag = try doc.getElementById("customer-information")
            let paymentMethodTag = try doc.getElementById("payment-method")
            let recipientMailTag = try doc.getElementById("recipient-email")
            let invoiceItemsPosition = try doc.getElementById("total")
            let totalFeeTag = try doc.getElementById("total-fee")
            
            let customer = AppDataManager.shared.getCustomer(customerID: invoice.customerID)!
            
            // elements to be appended
            let logoImageURI = invoice.userInfo.logoImageURI
            let invoiceIdElement = "Invoice: #\(String(describing: invoice.invoiceID))"
            let issueDateElement = "Date Issued: \(dateFormatter.string(from: Date()))<br>"
            let companyInfoElement = """
               <strong>\(invoice.userInfo.companyName)</strong>
               <br>
               \(invoice.userInfo.companyAddress.replacingOccurrences(of: "\n", with: "<br>"))
            """
            let customerInfoElement = """
                <strong>\(customer.information.customerName)</strong>
                <br>
                \(customer.information.eMailAddress)
            """
            let paymentMethodElement = invoice.userInfo.paymentMethod
            let recipientMailElement = invoice.userInfo.eMailAddress
            let invoiceItemsElement = enumerateItems(from: invoice)
            let totalFeeElement = "Total: $ \(self.getTotalFee(for: invoice))"
            
            // append elements to template
            try logoTag?.attr("src", logoImageURI.absoluteString)
            try invoiceIdTag?.append(invoiceIdElement)
            try issueDateTag?.append(issueDateElement)
            try companyInfoTag?.append(companyInfoElement)
            try customerInfoTag?.append(customerInfoElement)
            try paymentMethodTag?.append(paymentMethodElement)
            try recipientMailTag?.append(recipientMailElement)
            try invoiceItemsPosition?.before(invoiceItemsElement)
            try totalFeeTag?.append(totalFeeElement)
            
            htmlString = try doc.html()
            
        } catch {
            print(error)
        }
        
        return htmlString
    }
    
    func enumerateItems(from invoice: Invoice) -> String {
        let dateFormatter = DateFormatter()
        let items = invoice.invoiceItems
        var itemsHTMLString = ""
        for item in items {
            let title = item.eventName
            let hourlyRate = item.price
            let startTime: Date = item.startDateTime
            let durationInSecond: Int = item.durationMinutes*60
            let durationInMinute: Int = item.durationMinutes
            let durationInHour: Float = Float(durationInMinute != 0 ? durationInMinute/60: 0)
            let endTime: Date = item.startDateTime.addingTimeInterval(TimeInterval(durationInSecond))
            dateFormatter.dateFormat = "MM/dd"
            let monthString = dateFormatter.string(from: startTime)
            dateFormatter.dateFormat = "HH:mm"
            let startTimeString = dateFormatter.string(from: startTime)
            // what if endTime leaps over 24:00?
            let endTimeString = dateFormatter.string(from: endTime)
            let itemHTMLString = """
            <tr class="item">
                <td>
                    \(title)<br>
                    \(monthString), from \(startTimeString) to \(endTimeString)
                </td>
                <td>$ \(Int(Float(hourlyRate)*durationInHour))</td>
            </tr>
            """
            itemsHTMLString.append(itemHTMLString)
        }
        itemsHTMLString.append("")
        return itemsHTMLString
    }
    
    // same functionality to setupTotalIncome method above?
    func getTotalFee(for invoice: Invoice) -> Int {
        var sum: Int = 0
        let items = invoice.invoiceItems
        for item in items {
            let hourlyRate = item.price
            let durationInMinute: Int = item.durationMinutes
            let durationInHour: Float = Float(durationInMinute != 0 ? durationInMinute/60: 0)
            let fee: Int = Int(Float(hourlyRate)*durationInHour)
            sum += fee
        }
        return sum
    }
    
    func generatePDF(invoice: Invoice) -> NSMutableData {
        let fmt = UIMarkupTextPrintFormatter(markupText: getHTMLString(for: invoice))
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)
        // specify postscript point (1pt = 0.0352778cm)
        // A4, 72 dpi
        let paperWidth: Double = 595.2
        let paperHeight: Double = 841.8
        let screenWidthInInch = UIScreen.main.bounds.width/0.75
        let marginInInch = screenWidthInInch*0.04
        let page = CGRect(x: marginInInch, y: 0.0, width: paperWidth, height: paperHeight)
        render.setValue(page, forKey: "paperRect")
        render.setValue(page, forKey: "printableRect")
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        for i in 0..<render.numberOfPages {
            UIGraphicsBeginPDFPage()
            render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        UIGraphicsEndPDFContext()
        return pdfData
    }
}
