//
//  PDFGenerator.swift
//  InvoiceManager
//
//  Created by Yusuke Ishihara on 2022-07-18.
//

import Foundation
import PDFKit
import SwiftSoup

class PDFGenerator {
    
    enum HTMLFileError: Error {
        case runtimeError(String)
    }
    
    // swiftlint:disable:next function_body_length
    private static func getHTMLString(for invoice: Invoice) -> String {
        var htmlString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        do {
            guard let filePath = Bundle.main.path(forResource: "invoice_template", ofType: "html") else {
                throw HTMLFileError.runtimeError("Path for the template file is invalid.")
            }
            let template = try String(contentsOfFile: filePath, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(template)
            let customer = AppDataManager.shared.getCustomer(customerID: invoice.customerID)!
            
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
    
    private static func enumerateItems(from invoice: Invoice) -> String {
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
    
    private static func getTotalFee(for invoice: Invoice) -> Int {
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
    
    static func generatePDF(for invoice: Invoice) -> NSMutableData {
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
