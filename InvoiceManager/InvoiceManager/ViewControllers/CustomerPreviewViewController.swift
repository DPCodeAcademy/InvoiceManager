//
//  CustomerPreviewViewController.swift
//  InvoiceManager
//
//  Created by Kaiya Takahashi on 2022-07-11.
//

import UIKit

class CustomerPreviewViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var companyLogo: UIImageView!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var companyAdressLabel: UILabel!
    @IBOutlet var paymentMethodLabel: UILabel!
    @IBOutlet var companyEmailLabel: UILabel!
    @IBOutlet var invoiceIDLabel: UILabel!
    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var customerEmailLabel: UILabel!
    @IBOutlet var addItemBtn: UIButton!
    @IBOutlet var itemCollectionView: UICollectionView!
    @IBOutlet var totalIncomeLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var PDFBtn: UIButton!

    // この画面に進んだ時点でdateとcustomerがnilになるケースはあり得るのか？
    var date: Date?
    var customer: Customer?

    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    var dataSource: DataSourceType!
    var model = Model()

    enum ViewModel {
        typealias Section = Int

        typealias Item = InvoiceItem
    }

    // optional である必要あるか？　unwrapしないと使えないので、使いづらい
    struct Model {
        var invoice: Invoice?
    }

    init?(coder: NSCoder, customer: Customer, date: Date) {
        super.init(coder: coder)
        self.customer = customer
        self.date = date
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customer = nil
        self.date = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = createDataSource()
        itemCollectionView.collectionViewLayout = createLayout()
        update()
        setupInformationView()
    }

    func setupInformationView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let month: String
        let customerName = customer?.information.customerName
        if let date = date, let customerName = customerName {
            month = dateFormatter.string(from: date)
            titleLabel.text = "\(customerName)'s Invoice in \(month)"
        } else {
            titleLabel.text = "No Data"
        }

        companyLogo.image = model.invoice?.userInfo.logoImage ?? UIImage(systemName: "building.fill")
        companyNameLabel.text = model.invoice?.userInfo.companyName
        companyAdressLabel.text = model.invoice?.userInfo.companyAddress
        paymentMethodLabel.text = model.invoice?.userInfo.paymentMethod
        companyEmailLabel.text = model.invoice?.userInfo.eMailAddress

        invoiceIDLabel.text = "#\(customer?.customerID ?? 0)"
        customerNameLabel.text = customer?.information.customerName ?? "No Data"
        customerEmailLabel.text = customer?.information.eMailAddress ?? "No Data"
        itemCollectionView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        setupTotalIncome(invoiceItems: model.invoice!.invoiceItems)
    }

    func update() {
        if let customer = customer, let date = date {
            model.invoice = AppDataManager.shared.getInvoice(customerID: customer.customerID, month: date.getMonth(), year: date.getYear())
            statusLabel.text = AppDataManager.shared.hasInvoiceHistory(customerID: customer.customerID, month: date.getMonth(), year: date.getYear()) ? "Sent" : "Unsent"
        }

        updateCollectionView()
    }

    func updateCollectionView() {
        var sectionID = [ViewModel.Section]()
        let itemsBySection = model.invoice!.invoiceItems.reduce(into: [ViewModel.Section: [ViewModel.Item]]()) { partialResult, eventDetails in
            partialResult[0, default: []].append(eventDetails)
        }

        sectionID.append(0)
        dataSource.applySnapshotUsing(sectionIDs: sectionID, itemsBySeciton: itemsBySection)
    }

    func createDataSource() -> DataSourceType {
        dataSource = DataSourceType(collectionView: itemCollectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> EventDetailsCollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailsCell", for: indexPath) as! EventDetailsCollectionViewCell
            cell.eventDateLabel.text = self.twoDateIntoString(startDate: itemIdentifier.startDateTime, duration: itemIdentifier.durationMinutes)
            cell.eventNameLabel.text = itemIdentifier.eventName
            cell.eventIncomeLabel.text = "$\(itemIdentifier.price)"
            return cell
        })

        return dataSource
    }

    func setupTotalIncome(invoiceItems: [InvoiceItem]) {
        var totalIncome: Int = 0
        for invoiceItem in invoiceItems {
            totalIncome += invoiceItem.price
        }
        totalIncomeLabel.text = "$\(totalIncome)"
    }

    func twoDateIntoString(startDate: Date, duration: Int) -> String {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "MM/d, HH:mm"
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "HH:mm"
        let endDate = Date(timeInterval: TimeInterval(duration*60), since: startDate)
        let strDate = "\(startDateFormatter.string(from: startDate))-\(endDateFormatter.string(from: endDate))"
        return strDate
    }

    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // swiftlint: disable function_body_length
    func getHTMLString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // 1px = 0.75 postscript point
        // paper size (a4) -> w:595.2 [pt], h:841.8 [pt]
        // 595.2pt -> 793.6px, 841.8pt -> 1122.4px
        let contentWidthInPixel = 793.6
        
        let htmlString = """
            <!doctype html>
            <html>
            <head>
                <meta charset="utf-8">
                <style>
                    .invoice-box {
                        max-width: \(Int(contentWidthInPixel))px;
                        margin: 0;
                        padding: 30px;
                        border: 1px solid #eee;
                        box-shadow: 0 0 10px rgba(0, 0, 0, .15);
                        font-size: 16px;
                        line-height: 24px;
                        font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
                        color: #555;
                    }
        
                    .invoice-box table {
                        width: 100%;
                        line-height: inherit;
                        text-align: left;
                    }
        
                    .invoice-box table td {
                        padding: 5px;
                        vertical-align: top;
                    }
        
                    .invoice-box table tr td:nth-child(2) {
                        text-align: right;
                    }
        
                    .invoice-box table tr.top table td {
                        padding-bottom: 20px;
                    }
        
                    .invoice-box table tr.top table td.title {
                        font-size: 45px;
                        line-height: 45px;
                        color: #333;
                    }
        
                    .invoice-box table tr.information table td {
                        padding-bottom: 40px;
                    }
        
                    .invoice-box table tr.heading td {
                        background: #eee;
                        border-bottom: 1px solid #ddd;
                        font-weight: bold;
                    }
        
                    .invoice-box table tr.details td {
                        padding-bottom: 20px;
                    }
        
                    .invoice-box table tr.item td{
                        border-bottom: 1px solid #eee;
                    }
        
                    .invoice-box table tr.item.last td {
                        border-bottom: none;
                    }
        
                    .invoice-box table tr.total td:nth-child(2) {
                        border-top: 2px solid #eee;
                        font-weight: bold;
                    }
        
                    @media only screen and (max-width: 600px) {
                        .invoice-box table tr.top table td {
                            width: 100%;
                            display: block;
                            text-align: center;
                        }
        
                        .invoice-box table tr.information table td {
                            width: 100%;
                            display: block;
                            text-align: center;
                        }
                    }
        
                    /** RTL **/
                    .rtl {
                        direction: rtl;
                        font-family: Tahoma, 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
                    }
        
                    .rtl table {
                        text-align: right;
                    }
        
                    .rtl table tr td:nth-child(2) {
                        text-align: left;
                    }
                </style>
            </head>
        
            <body>
            <div class="invoice-box">
                <div>
                    <img style="display: block; margin-left: auto; margin-right: auto;" src="\(model.invoice!.userInfo.logoImageURI)" alt="logo" />
                </div>
                <table cellpadding="0" cellspacing="0">
                    <tr class="top">
                        <td colspan="2">
                            <table>
                                <tr>
                                    <td class="title">
                                    </td>
                                    <td>
                                        Invoice: #\(String(describing: model.invoice!.invoiceID))
                                    </td>
                                </tr>
                                <tr>
                                    <td class="title">
                                    </td>
                                    <td>
                                        Date Issued: \(dateFormatter.string(from: Date()))<br>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
        
                    <tr class="information">
                        <td colspan="2">
                            <table>
                                <tr>
                                    <td>
                                        <strong>\(model.invoice!.userInfo.companyName)</strong>
                                        <br>
                                        \(model.invoice!.userInfo.companyAddress.replacingOccurrences(of: "\n", with: "<br>"))
                                    </td>
                                    <td>
                                        <strong>\(customer!.information.customerName)</strong>
                                        <br>
                                        \(customer!.information.eMailAddress)
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="heading">
                        <td>Payment Method</td>
                        <td>Email</td>
                    </tr>
                    <tr class="details">
                        <td>\(model.invoice!.userInfo.paymentMethod)</td>
                        <td>\("To be retrieved from AppDataManager")</td>
                    </tr>
                    <tr class="heading">
                        <td>Item</td>
                        <td>Price</td>
                    </tr>
        
                    \(enumerateItems(from: model.invoice!))
        
                    <tr class="total">
                        <td></td>
                        <td>Total: $ \(self.getTotalFee(for: model.invoice!))</td>
                    </tr>
                </table>
            </div>
            </body>
            </html>
        """
        
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
                <tr class=\"item\">
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
    
    func generatePDF() -> NSMutableData {
        let fmt = UIMarkupTextPrintFormatter(markupText: self.getHTMLString())
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
            UIGraphicsBeginPDFPage();
            render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext();
        
        return pdfData
    }

    @IBAction func sendBtnTapped(_ sender: UIButton) {
    }

    @IBAction func PDFBtnTapped(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "pdfViewer") as! PDFViewerViewController
        nextVC.content = generatePDF()
        self.present(nextVC, animated: true, completion: nil)
    }

    @IBAction func addItemBtnTapped(_ sender: UIButton) {
    }

}

extension UICollectionViewDiffableDataSource {
    func applySnapshotUsing(sectionIDs: [SectionIdentifierType], itemsBySeciton: [SectionIdentifierType: [ItemIdentifierType]], sectionRetainedIfEmpty: Set<SectionIdentifierType> = Set<SectionIdentifierType>()) {
        applySnapshotUsing(sectionIDs: sectionIDs, itemsBySection: itemsBySeciton, animatingDifferences: true, sectionRetainedIfEmpty: sectionRetainedIfEmpty)
    }

    func applySnapshotUsing(sectionIDs: [SectionIdentifierType], itemsBySection: [SectionIdentifierType: [ItemIdentifierType]], animatingDifferences: Bool, sectionRetainedIfEmpty: Set<SectionIdentifierType> = Set<SectionIdentifierType>()) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()

        for sectionID in sectionIDs {
            guard let sectionItems = itemsBySection[sectionID], sectionItems.count > 0 || sectionRetainedIfEmpty.contains(sectionID) else { continue }
            snapshot.appendSections([sectionID])
            snapshot.appendItems(sectionItems, toSection: sectionID)
        }
        self.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
