//
//  CustomerPreviewViewController.swift
//  InvoiceManager
//
//  Created by Kaiya Takahashi on 2022-07-11.
//
import UIKit

class CustomerPreviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
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

    var date: Date!
    var customer: Customer!
    var invoice: Invoice!

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

        itemCollectionView.collectionViewLayout = createLayout()
        update()
        setupInformationView()
    }

    func setupInformationView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let month: String
        let customerName = customer.information.customerName
        month = dateFormatter.string(from: date)
        titleLabel.text = "\(customerName)'s Invoice in \(month)"

        companyLogo.image = invoice.userInfo.logoImage ?? UIImage(systemName: "building.fill")
        companyNameLabel.text = invoice.userInfo.companyName
        companyAdressLabel.text = invoice.userInfo.companyAddress
        paymentMethodLabel.text = invoice.userInfo.paymentMethod
        companyEmailLabel.text = invoice.userInfo.eMailAddress

        invoiceIDLabel.text = "#\(customer.customerID)"
        customerNameLabel.text = customer.information.customerName
        customerEmailLabel.text = customer.information.eMailAddress
        itemCollectionView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        setupTotalIncome(invoiceItems: invoice!.invoiceItems)
    }

    func update() {
        self.invoice = AppDataManager.shared.getInvoice(customerID: customer.customerID, month: date.getMonth(), year: date.getYear())
        statusLabel.text = AppDataManager.shared.hasInvoiceHistory(customerID: customer.customerID, month: date.getMonth(), year: date.getYear()) ? "Sent" : "Unsent"
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return invoice.invoiceItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailsCell", for: indexPath) as! EventDetailsCollectionViewCell
        cell.eventDateLabel.text = self.twoDateIntoString(startDate: invoice.invoiceItems[indexPath.item].startDateTime, duration: invoice.invoiceItems[indexPath.item].durationMinutes)
        cell.eventNameLabel.text = invoice.invoiceItems[indexPath.item].eventName
        cell.eventIncomeLabel.text = "$\(invoice.invoiceItems[indexPath.item].price)"
        return cell
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

    @IBAction func sendBtnTapped(_ sender: UIButton) {
    }

    @IBAction func PDFBtnTapped(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "pdfViewer") as! PDFViewerViewController
        nextVC.content = PDFGenerator.generatePDF(for: invoice)
        self.present(nextVC, animated: true, completion: nil)
    }

    @IBAction func addItemBtnTapped(_ sender: UIButton) {
    }

}
