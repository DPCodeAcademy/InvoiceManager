//
//  ImportCalenderViewController.swift
//  InvoiceManager
//
//  Created by 鈴木啓司 on 2022-06-23.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

struct ImportCustomer {
  var customerName: String
  var eMailAddress: String
}

struct ImportEventDetail: Hashable {
  var startTime: Date
  var durationTime: Int
  var attendees: [ImportCustomer]

  static func == (lhs: ImportEventDetail, rhs: ImportEventDetail) -> Bool {
    return lhs.startTime == rhs.startTime
  }

  func hash(into hasher: inout Hasher) {
      hasher.combine(startTime)
  }
}

struct ImportEvent: Hashable {
  var eventName: String
  var eventDetail: [ImportEventDetail]

  static func == (lhs: ImportEvent, rhs: ImportEvent) -> Bool {
    return lhs.eventName == rhs.eventName
  }

  func hash(into hasher: inout Hasher) {
      hasher.combine(eventName)
  }
}

class ImportCalenderViewController: UIViewController, EventSelectBoxDelegate, EventDetailPopupDelegate {
//    typealias DataSourceType = UICollectionViewDiffableDataSource<String, EventTest>
    typealias DataSourceType = UICollectionViewDiffableDataSource<String, ImportEventDetail>

    var dataSource: DataSourceType!
    var sections = [String]()
    var candidateEvent: [ImportEvent] = []
    var selectedEvent: [ImportEvent] = []

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

    let fromDatePicker = UIDatePicker()
    let toDatePicker = UIDatePicker()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()

        calenderEventsCollectionView.collectionViewLayout = createLayout()
        calenderEventsCollectionView.register(EventNamedSectionHeaderView.self, forSupplementaryViewOfKind: "header-element-kind", withReuseIdentifier: EventNamedSectionHeaderView.reuseIdentifier)
    }

	// MARK: delete nested navigation bar on top of screens
	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.navigationBar.isHidden = true
	}

    func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        let doneButton =  UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTapped))
        toolBar.setItems([doneButton], animated: true )

        return toolBar
    }

    func createDatePicker() {
        setupDatePicker(datePicker: fromDatePicker, date: Date.now, textField: fromField)
        setupDatePicker(datePicker: toDatePicker, date: Date(timeInterval: 60*60*24*30, since: Date.now), textField: toField)
    }

    func setupDatePicker(datePicker: UIDatePicker, date: Date, textField: UITextField) {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.date = date
        textField.inputView = datePicker
        textField.text = dateFormatter.string(from: date)
        textField.inputAccessoryView = createToolBar()
    }

    // MARK: collection view setting by Tomo
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {(_, _) -> NSCollectionLayoutSection in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header-element-kind", alignment: .top)

            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [sectionHeader]

            return section
        }
        return layout
    }

    // here is the place where async function to access to google api and get data will be
    func createDataSource () {
        dataSource = .init(collectionView: calenderEventsCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalenderEvent", for: indexPath) as! CalenderEventsCollectionViewCell
            cell.delegate = self
            cell.dateLabel.text = item.startTime.formatted()
			cell.timeLabel.text = "\(item.durationTime)"
            cell.evnetName = self.candidateEvent[indexPath.section].eventName
            cell.attendees = {
                let attendeesNameArray = item.attendees.map {$0.customerName}
                return attendeesNameArray.joined(separator: ", ")
            }()
            return cell
        })

        dataSource.supplementaryViewProvider = { (collectionView, _, indexPath) in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: "header-element-kind", withReuseIdentifier: EventNamedSectionHeaderView.reuseIdentifier, for: indexPath) as! EventNamedSectionHeaderView
            header.eventName = self.candidateEvent[indexPath.section].eventName
            header.delegate = self
            return header
        }

        var snapshot = NSDiffableDataSourceSnapshot<String, ImportEventDetail>()
        candidateEvent.forEach {
          snapshot.appendSections([$0.eventName])
          snapshot.appendItems($0.eventDetail, toSection: $0.eventName)
        }
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }

    @objc func doneButtonTapped() {
        if fromField.isFirstResponder {
            fromDate = fromDatePicker.date
            self.fromField.text = dateFormatter.string(from: fromDatePicker.date)
        } else {
            toDate = toDatePicker.date
            self.toField.text = dateFormatter.string(from: toDatePicker.date)
        }
        self.view.endEditing(true)

        if fromDatePicker.date < toDatePicker.date {
            importButton.isEnabled = true
        } else {
            importButton.isEnabled = false
        }
    }

    @IBAction func importButtonTapped(_ sender: UIButton) {
        // implementation for previous sign-in instance
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
    func fetchCalendarEvents(for user: GIDGoogleUser, from: GTLRDateTime, to: GTLRDateTime) {
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
            print(type(of: items))
            if items.count > 0 {
                // Do stuff with your events
                self.candidateEvent = self.convertGoogleItemArrayToImportEvents(googleEvents: items)
                self.createDataSource()
                // self.alert(title: "Fetched events", message: String(describing: items))
            } else {
                // No events
                print("sign in before fetch!")
            }
        }
    }

    func convertGoogleItemArrayToImportEvents(googleEvents: [GTLRCalendar_Event]) -> [ImportEvent] {
        var result: [ImportEvent] = []
        for googleEvent in googleEvents {
            guard let (eventName, eventDetail) = convertGoogleItemToImportEvent(googleEvent: googleEvent) else {
                continue
            }

            var targetIndex = -1
            for (index, elem) in result.enumerated() where elem.eventName == googleEvent.summary {
				targetIndex = index
				break
            }

			if targetIndex < 0 {
                let importEvent: ImportEvent = ImportEvent(eventName: eventName,
                                                           eventDetail: [eventDetail])
                result.append(importEvent)
            } else {
                result[targetIndex].eventDetail.append(eventDetail)
            }
        }
        return result
    }

    func convertGoogleItemToImportEvent(googleEvent: GTLRCalendar_Event) -> (String, ImportEventDetail)? {
        guard let eventName = googleEvent.summary else {
            return nil
        }
        guard let googleEventStart = googleEvent.start,
              let startDateTime = googleEventStart.dateTime?.date as Date? else {
            return nil
        }
        guard let googleEventEnd = googleEvent.end,
              let endDateTime = googleEventEnd.dateTime?.date as Date? else {
            return nil
        }

        var attendeesInfo: [ImportCustomer] = []
        if let attendees = googleEvent.attendees {
            for info in attendees {
                guard let displayName = info.displayName else {
                    continue
                }
                let eMailAddress = info.email ?? ""
                attendeesInfo.append(ImportCustomer(customerName: displayName,
                                                    eMailAddress: eMailAddress))
            }
        }

		let durationTime = Int(endDateTime.timeIntervalSince(startDateTime)) / 60
        let eventDetail: ImportEventDetail = ImportEventDetail(startTime: startDateTime,
                                                                durationTime: durationTime,
                                                                attendees: attendeesInfo)
        return (eventName, eventDetail)
    }

    func alert(title: String, message: String) {
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

    // MARK: user interact action by Tomo
    func checkmarkTapped(at eventName: String) {
        if selectedEvent.contains(where: { $0.eventName == eventName }) {
            for event in selectedEvent where event.eventName == eventName {
				selectedEvent = selectedEvent.filter { $0.eventName != eventName }
            }
        } else {
            for event in candidateEvent where event.eventName == eventName {
				selectedEvent.append(event)
            }
        }
    }

    func detailButtonTapped(show alertView: UIAlertController) {
        present(alertView, animated: true)
    }

    @IBAction func nextButtonTapped() {
		let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let invoiceListViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
		invoiceListViewController.navigationItem.setHidesBackButton(true, animated: true)
		for selEvent in selectedEvent {
			addEventToManager(event: selEvent)
		}
		self.navigationController?.pushViewController(invoiceListViewController, animated: true)
    }

    func addEventToManager(event: ImportEvent) {
        var eventDetails: [EventDetail] = []
        for detail in event.eventDetail {
            var iDs: [UInt16] = []
            for attendee in detail.attendees {
                if let customer = AppDataManager.shared.getCustomer(emailAddress: attendee.eMailAddress) {
                    iDs.append(customer.customerID)
                } else {
                    // Add newCustomer
                    let customerID = AppDataManager.shared.addNewCustomer(customerInfo: CustomerInformation(customerName: attendee.customerName,
                                                                                                             eMailAddress: attendee.eMailAddress,
                                                                                                             isAutoSendInvoice: true,
                                                                                                             customerRate: 0)).customerID
                    iDs.append(customerID)
                }
            }
            eventDetails.append(EventDetail(startDateTime: detail.startTime,
											durationMinutes: detail.durationTime,
                                            attendees: Set<UInt16>(iDs)))
        }
		_ = AppDataManager.shared.addUpdateEvent(event: Event(eventName: event.eventName,
																  eventRate: 0,
																  eventDetails: eventDetails))
    }
}
