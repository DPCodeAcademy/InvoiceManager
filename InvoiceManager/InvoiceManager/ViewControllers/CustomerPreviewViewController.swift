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

    var totalIncome: Int = 0
    var date: Date?
    var customer: Customer?
    var userSetting: UserSetting?

    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    var dataSource: DataSourceType!
    var model = Model()

    enum ViewModel {
        typealias Section = Int

        typealias Item = InvoiceItem
    }

    struct Model {
        var invoiceItems = [InvoiceItem]()
    }

    init?(coder: NSCoder, customer: Customer, date: Date) {
        super.init(coder: coder)
        self.customer = customer
        self.date = date
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customer = nil
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
        companyLogo.image = userSetting?.logoImage ?? UIImage(systemName: "person")
        companyNameLabel.text = userSetting?.companyName ?? "No Data"
        companyAdressLabel.text = userSetting?.companyAddress ?? "No Data"
        paymentMethodLabel.text = userSetting?.paymentMethod ?? "No Data"
        companyEmailLabel.text = userSetting?.eMailAddress ?? "No Data"

        invoiceIDLabel.text = "\(customer?.customerID ?? 0)"
        customerNameLabel.text = customer?.information.customerName ?? "No Data"
        customerEmailLabel.text = customer?.information.eMailAddress ?? "No Data"
        itemCollectionView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        setupTotalIncome(invoiceItems: model.invoiceItems)
    }

    func update() {
        if let customer = customer, let date = date {
            model.invoiceItems = AppDataManager.shared.getInvoice(customerID: customer.customerID, month: date.getMonth(), year: date.getYear()).invoiceItems
            statusLabel.text = AppDataManager.shared.hasInvoiceHistory(customerID: customer.customerID, month: date.getMonth(), year: date.getYear()) ? "Sent" : "Unsent"
        }
        userSetting = AppDataManager.shared.getUserSetting()

        updateCollectionView()
    }

    func updateCollectionView() {
        var sectionID = [ViewModel.Section]()
        let itemsBySection = model.invoiceItems.reduce(into: [ViewModel.Section: [ViewModel.Item]]()) { partialResult, eventDetails in
            partialResult[0, default: []].append(eventDetails)
        }

        sectionID.append(0)
        dataSource.applySnapshotUsing(sectionIDs: sectionID, itemsBySeciton: itemsBySection)
    }

    func createDataSource() -> DataSourceType {
        dataSource = DataSourceType(collectionView: itemCollectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> EventDetailsCollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailsCell", for: indexPath) as! EventDetailsCollectionViewCell
            cell.eventDateLabel.text = self.twoDateIntoString(startDate: itemIdentifier.startDateTime, endDate: Date(timeInterval: TimeInterval(itemIdentifier.durationMinutes), since: itemIdentifier.startDateTime))
            cell.eventNameLabel.text = itemIdentifier.eventName
            let income = itemIdentifier.price * itemIdentifier.durationMinutes
            cell.eventIncomeLabel.text = self.formatAsCurrency(number: income)
            return cell
        })

        return dataSource
    }

    func formatAsCurrency(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        return "\(numberFormatter.string(for: number) ?? "")"
    }

    func calculateTimeDifferenceInHours(startTime: Date, endTime: Date) -> Int {
        let diffComponents = Calendar.current.dateComponents([.hour], from: startTime, to: endTime)
        return diffComponents.hour!
    }

    func setupTotalIncome(invoiceItems: [InvoiceItem]) {
        for invoiceItem in invoiceItems {
            totalIncome += invoiceItem.price * invoiceItem.durationMinutes
        }
        totalIncomeLabel.text = formatAsCurrency(number: totalIncome)
    }

    func twoDateIntoString(startDate: Date, endDate: Date) -> String {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "MM/d, HH:mm"
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "HH:mm"
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
