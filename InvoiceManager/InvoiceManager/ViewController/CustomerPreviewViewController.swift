//
//  CustomerPreviewViewController.swift
//  InvoiceManager
//
//  Created by Kaiya Takahashi on 2022-07-05.
//

import UIKit


class CustomerPreviewViewController: UIViewController {
    
    let tempEvents: [EventDetails] = [
        EventDetails(eventStartTime: Date.now, eventEndTime: Date(timeInterval: 60*60*4, since: Date.now), eventName: "Programming class", hourlyWage: 20),
        EventDetails(eventStartTime: Date.now, eventEndTime: Date(timeInterval: 60*60*4, since: Date.now), eventName: "Football class", hourlyWage: 30),
        EventDetails(eventStartTime: Date.now, eventEndTime: Date(timeInterval: 60*60*6, since: Date.now), eventName: "Programming class", hourlyWage: 20),
        EventDetails(eventStartTime: Date.now, eventEndTime: Date(timeInterval: 60*60*4, since: Date.now), eventName: "Algorithm class", hourlyWage: 10),
        EventDetails(eventStartTime: Date.now, eventEndTime: Date(timeInterval: 60*60*4, since: Date.now), eventName: "Linguistic class", hourlyWage: 15),
        EventDetails(eventStartTime: Date.now, eventEndTime: Date(timeInterval: 60*60*4, since: Date.now), eventName: "Music class", hourlyWage: 25),
        EventDetails(eventStartTime: Date.now, eventEndTime: Date(timeInterval: 60*60*4, since: Date.now), eventName: "Baseball class", hourlyWage: 45),
    ]
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var companyLogo: UIImageView!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var companyAdressLabel: UILabel!
    @IBOutlet var paymentMethodLabel: UILabel!
    @IBOutlet var companyEmailLabel: UILabel!
    @IBOutlet var invoiceIDLabel: UILabel!
    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var customerEmailLabel: UILabel!
    @IBOutlet var itemCollectionView: UICollectionView!
    @IBOutlet var totalIncomeLabel: UILabel!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var PDFBtn: UIButton!
    @IBOutlet var statusLabel: UILabel!
    
    var totalIncome: Int = 0
    var date: Date?
    var customer: Customer?
    var invoiceHistory: InvoiceHistory?
    var userSetting: UserSetting?
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    var dataSource: DataSourceType!
    var model = Model()
    
    enum ViewModel {
        typealias Section = Int
        
        typealias Item = EventDetails
    }
    
    struct Model {
        var eventsDetails = [EventDetails]()
    }
    
    struct EventDetails: Hashable {
        let eventStartTime: Date
        let eventEndTime: Date
        let eventName: String
        let hourlyWage: Int
    }
    
//    enum SectionHeader: String {
//        case kind = "SectionHeader"
//        case reuse = "HeaderView"
//
//        var identifier: String {
//            return rawValue
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        itemCollectionView.register(EventNamedSectionHeaderView.self, forSupplementaryViewOfKind: SectionHeader.kind.identifier, withReuseIdentifier: SectionHeader.reuse.identifier)
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
        if let date = date, let customerName = customerName  {
            month = dateFormatter.string(from: date)
            titleLabel.text = "\(customerName)'s Invoice in \(month)"
        } else {
            titleLabel.text = "No Data"
        }
        companyLogo.image = userSetting?.logoImage ?? UIImage(systemName: "person")
        companyNameLabel.text = userSetting?.companyName ?? "No Data"
        companyAdressLabel.text = userSetting?.companyAddress ?? "No Data"
        paymentMethodLabel.text = userSetting?.paymentMethod ?? "No Data"
        companyEmailLabel.text = userSetting?.companyEmail ?? "No Data"
        
        invoiceIDLabel.text = "\(customer?.customerID ?? 0)"
        customerNameLabel.text = customerName ?? "No Data"
        customerEmailLabel.text = customer?.information.eMailAddress ?? "No Data"
        itemCollectionView.backgroundColor = .systemGray6
        setupTotalIncome(eventsDetails: tempEvents)
    }
    
    func update() {
        // fetch data
        model.eventsDetails = tempEvents
        // update CollectionView
        updateCollectionView()
    }
    
    func updateCollectionView() {
        // create ViewModel instance from Model instance
        var sectionID = [ViewModel.Section]()
        let itemsBySection = model.eventsDetails.reduce(into: [ViewModel.Section: [ViewModel.Item]]()) { partialResult, eventDetails in
            partialResult[0, default: []].append(eventDetails)
        }
        // apply snapshot
        sectionID.append(0)
        dataSource.applySnapshotUsing(sectionIDs: sectionID, itemsBySeciton: itemsBySection)
    }
    
    func createDataSource() -> DataSourceType {
        dataSource = DataSourceType(collectionView: itemCollectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> EventDetailsCollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailsCell", for: indexPath) as! EventDetailsCollectionViewCell
            cell.eventDateLabel.text = self.twoDateIntoString(startDate: itemIdentifier.eventStartTime, endDate: itemIdentifier.eventEndTime)
            cell.eventNameLabel.text = itemIdentifier.eventName
            let income = itemIdentifier.hourlyWage * self.calculateTimeDifferenceInHours(startTime: itemIdentifier.eventStartTime, endTime: itemIdentifier.eventEndTime)
            cell.eventIncomeLabel.text = self.formatAsCurrency(number: income)
            return cell
        })
        
//        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: SectionHeader.kind.identifier, withReuseIdentifier: SectionHeader.reuse.identifier, for: indexPath) as! EventNamedSectionHeaderView
//            header.eventNameLabel.text = "Item"
//            return header
//        }
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
    
    func setupTotalIncome(eventsDetails: [EventDetails]) {
        for eventDetails in eventsDetails {
            totalIncome += eventDetails.hourlyWage * calculateTimeDifferenceInHours(startTime: eventDetails.eventStartTime, endTime: eventDetails.eventEndTime)
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
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: SectionHeader.kind.identifier, alignment: .top)
//        header.pinToVisibleBounds = true
//        section.boundarySupplementaryItems = [header]
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func PDFBtnTapped(_ sender: UIButton) {
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
