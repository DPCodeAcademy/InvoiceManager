//
//  ImportCalenderViewController.swift
//  InvoiceManager
//
//  Created by 鈴木啓司 on 2022-06-23.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST


// test model for development. we need to adjust when real models are created
struct StudentTest{
    let name: String
    let email: String
}

struct EventTest: Hashable{
    
    let title: String
    let attendees: [StudentTest]
    let startTime: String // ex 19:00
    let finishTime: String // ex 21:00
    let date: String // ex 2022/4/27
    let isTargetForInvoice: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    static func == (lhs: EventTest, rhs: EventTest) -> Bool {
        return lhs.title == rhs.title
    }
}

struct ImportedDataTest{
    var data = [String: [EventTest]]()
}

class ImportCalenderViewController: UIViewController {
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    enum ViewModel{
        typealias Section = EventTest
        typealias Item = EventTest
    }
    
    var dataSource: DataSourceType!
    
    @IBOutlet var fromField: UITextField!
    @IBOutlet var toField: UITextField!
    @IBOutlet var importButton: UIButton!
    @IBOutlet var calenderEventsCollectionView: UICollectionView!
    
    // test client id (generated by following instruction of  https://developers.google.com/identity/sign-in/ios/start-integrating)
    lazy var signInConfig: GIDConfiguration = {
        let clientId = ProcessInfo.processInfo.environment["OAUTH_CLIENT_ID"]!
        return GIDConfiguration(clientID: clientId)
    }()
    
    // add access scope for google apis
    let scopes = [
        "https://www.googleapis.com/auth/calendar.readonly",
        "https://www.googleapis.com/auth/calendar.events.readonly"
    ]
    
    var fromDate: Date?
    var toDate: Date?
    
    let datePicker = UIDatePicker()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
    }
    
    func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton =  UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTapped))
        toolBar.setItems([doneButton], animated: true )
        
        return toolBar
    }
    
    func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date.now
        
        fromField.inputView = datePicker
        fromField.text = dateFormatter.string(from: Date.now)
        fromField.inputAccessoryView = createToolBar()
        
        let aMonthLater = Date(timeInterval: 2600000, since: Date.now)
        toField.inputView = datePicker
        toField.text = dateFormatter.string(from: aMonthLater)
        toField.inputAccessoryView = createToolBar()
    }
    
    //MARK: collection view setting by Tomo
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: calenderEventsCollectionView) { (collectionView, indexPath, item) -> calenderEventsCollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalenderEvent", for: indexPath) as! calenderEventsCollectionViewCell
            cell.dateLabel.text = item.date
            cell.timeLabel.text = "\(item.startTime) - \(item.finishTime)"
            cell.attendeesListLabel.text = {
                let attendeesNameArray = item.attendees.map {$0.name}
                return attendeesNameArray.joined(separator: ", ")
            }()
            return cell
        }
        
        // should design header here
        return dataSource
    }
    func createLayout() -> UICollectionViewCompositionalLayout{
        
        // need to add section header which represent event name and check box
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "SectionHeader", alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @objc func doneButtonTapped() {
        if fromField.isFirstResponder {
            fromDate = datePicker.date
            self.fromField.text = dateFormatter.string(from: datePicker.date)
        } else {
            toDate = datePicker.date
            self.toField.text = dateFormatter.string(from: datePicker.date)
        }
        self.view.endEditing(true)
        
        if let fromDate = fromDate, let toDate = toDate {
            if fromDate < toDate {
                importButton.isEnabled = true
            } else {
                importButton.isEnabled = false
            }
        }
        
    }
    
    
    @IBAction func importButtonTapped(_ sender: UIButton) {
        //implementation for previous sign-in instance
        //        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
        //            GIDSignIn.sharedInstance.restorePreviousSignIn()
        //            self.fetchCalendarEvents(for: GIDSignIn.sharedInstance.currentUser!)
        //        } else { }
        
        // initial login
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: self,
            hint: nil,
            additionalScopes: scopes
        ) { user, error in
            // implement handler
            print("\(String(describing: user)) logged in")
            
            guard let user = GIDSignIn.sharedInstance.currentUser else { return }
            
            // fetch events for the last 30 days
            let period: TimeInterval = 60*60*24*30
            let startDateTime = GTLRDateTime(date: Calendar.current.startOfDay(for: Date()-period))
            let endDateTime = GTLRDateTime(date: Date().addingTimeInterval(60*60*24))
            
            self.fetchCalendarEvents(for: user, from: startDateTime, to: endDateTime)
        }
    }
    
    
    // test function for checking calendar event fetch
    func fetchCalendarEvents(for user: GIDGoogleUser, from: GTLRDateTime ,to: GTLRDateTime) {
        let calendarService = GTLRCalendarService()
        let authentication = user.authentication
        calendarService.authorizer = authentication.fetcherAuthorizer()
        
        let eventsListQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        
        eventsListQuery.timeMin = from
        eventsListQuery.timeMax = to
        calendarService.executeQuery(eventsListQuery) { ticket, result, error in
            guard error == nil, let items = (result as? GTLRCalendar_Events)?.items else {
                return
            }
            if items.count > 0 {
                // Do stuff with your events
                self.alert(title: "Fetched events", message: String(describing: items))
            } else {
                // No events
                print("sign in before fetch!")
            }
        }
    }
    
    func alert(title:String, message:String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            )
        )
        present(alertController, animated: true)
    }
}
