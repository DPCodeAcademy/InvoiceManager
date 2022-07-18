//
//  PDFViewerViewController.swift
//  InvoiceManager
//
//  Created by Yusuke Ishihara on 2022-07-17.
//

import UIKit
import PDFKit

class PDFViewerViewController: UIViewController {
    var content: NSMutableData!
    override func viewDidLoad() {
        super.viewDidLoad()

        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        pdfView.maxScaleFactor = 4.0
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.autoScales = true
        pdfView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        pdfView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        if let document = PDFDocument(data: content as Data) {
            pdfView.document = document
            print(document)
        }
    }
}
