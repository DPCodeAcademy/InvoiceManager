//
//  AppDataManager.swift
//  InvoiceManager
//
//  Created by 鈴木啓司 on 2022-06-29.
//

import Foundation

class AppDataManager {

    static let shared = AppDataManager()

	private var customerList: CustomerViewModel
    private var eventList: EventViewModel
    private var invoiceHistoryList: InvoiceHistoryViewModel
    private var userSetting: UserSetting

	// -------------------------------------
    // Get methods
    // -------------------------------------

    func getCustomerList() -> [Customer] {
        return customerList.getCustomerList()
    }

    func getCustomer(customerID: UInt16) -> Customer? {
        return customerList.getCustomer(customerID: customerID)
    }

    func getCustomer(emailAddress: String) -> Customer? {
        return customerList.getCustomer(eMailAddress: emailAddress)
    }

    func getCustomer(customerName: String) -> [Customer] {
        return customerList.getCustomer(customerName: customerName)
    }

	func getEventList() -> [Event] {
        return eventList.getEventList()
    }
	func getEventList(in priod: Date) -> [Event] {
		return eventList.getEventList(in: priod)
	}
	func getEventOrganizedList(in priod: Date) -> [EventType] {
		return eventList.getEventOrganizedList(in: priod)
	}

    func getEvent(eventName: String) -> Event? {
        return eventList.getEvent(eventName: eventName)
    }

	func getInvoice(customerID: UInt16, dateIssed: Date ) -> Invoice {
		return self.getInvoice(customerID: customerID, month: dateIssed.getMonth(), year: dateIssed.getYear())
	}

	func getInvoice(customerID: UInt16, month: Month, year: Int ) -> Invoice {
		if let invoice = invoiceHistoryList.getInvoice(customerID: customerID, month: month, year: year) {
			return invoice
		}
		return self.createNewInvoice(customerID: customerID, month: month, year: year )
	}
    
	func getUserSetting() -> UserSetting {
        return userSetting
    }

	// -------------------------------------
	// Has methods
	// -------------------------------------
	func hasInvoiceHistory(customerID: UInt16, month: Month, year: Int ) -> Bool {
		return invoiceHistoryList.hasInvoiceHistory(customerID: customerID, month: month, year: year)
	}

	func hasInvoiceHistory(customerID: UInt16, dateIssued: Date) -> Bool {
		return invoiceHistoryList.hasInvoiceHistory(customerID: customerID, month: dateIssued.getMonth(), year: dateIssued.getYear())
	}

    // -------------------------------------
    // Add methods
    // -------------------------------------
    func addNewCustomer(customerInfo: CustomerInformation) -> Customer {
        return customerList.createNewCustomer(newCustomerInfo: customerInfo)
    }

	func addUpdateEvent(event: Event) -> Event {
        //  If the argument event does not exist, add
        //  If it exists, update the event with additional information
        return eventList.addAndUpdateEvent(event: event)
    }

	func addInvoiceHistory(invoive: Invoice) {
		return invoiceHistoryList.addInvoiceHistory(invoice: invoive)
    }

	// -------------------------------------
    // Update methods
    // -------------------------------------
    func updateCustomerInfo(customerID: UInt16, customerInfo: CustomerInformation) -> Bool {
        return customerList.updateCustomerInfo(customerID: customerID, information: customerInfo)
    }

	func updateEvent(event: Event) -> Bool {
        return eventList.updateEvent(event: event)
    }

	func updateInvoiceHistory(invoice: Invoice) -> Bool {
		return invoiceHistoryList.updateInvoiceHistory(invoice: invoice)
	}

    func updateUserSetting(userSetting: UserSetting) {
        self.userSetting = userSetting
    }

    // -------------------------------------
    // Remove methods
    // -------------------------------------
	func removeCustomer(customerID: UInt16) {
        customerList.removeCustomer(customerID: customerID)
        eventList.removeAttendee(customerID: customerID)
        invoiceHistoryList.removeInvoiceHistory(customerID: customerID)
    }

    func removeEvent(eventName: String) {
        eventList.removeEvent(eventName: eventName)
    }

	// -------------------------------------
    // Data store & restore methods
    // -------------------------------------
    func restoreData() {
        // Restore all data from iPhone local storage
        setSampleData()
    }

    private func storeData() {
        // Store all data into iPhone local storage
        // Call this method every time user changes information.
    }

	// -------------------------------------
	// Private methods
	// -------------------------------------
	private init() {
        customerList = CustomerViewModel()
        eventList = EventViewModel()
        invoiceHistoryList = InvoiceHistoryViewModel()
        userSetting = UserSetting()
    }

	private func createNewInvoice( customerID: UInt16, month: Month, year: Int ) -> Invoice {
		var invoice = invoiceHistoryList.createNewInvoiceHistory(customerID: customerID, dateIssued: Date.getEndOfMonthDate(month: month, year: year))
		invoice.userInfo = getUserSetting()

		let customerEvents = eventList.getCustomerEventList(customerID: customerID, month: month, year: year)
		for customerEvent in customerEvents {
			customerEvent.eventDetails.forEach {
				if !$0.attendees.contains(customerID) {
					return
				}
				let price = customerEvent.eventRate * $0.durationMinutes / 60
				let invoiceItem = InvoiceItem(startDateTime: $0.startDateTime, durationMinutes: $0.durationMinutes, price: price, eventName: customerEvent.eventName )
				invoice.invoiceItems.append(invoiceItem)
			}
		}

		// Sort by event start date
		invoice.invoiceItems.sort {
			$0.startDateTime < $1.startDateTime
		}

		return invoice
	}

    // ------------------------------------------------------
    // Temporary methods. These methods should be deleted.
    // ------------------------------------------------------
    private func setSampleData() {
        setSampleCustomer()
        setSampleEvent()
        setSampleInvoiceHistory()
    }

	private var c1: UInt16 = 0
    private var c2: UInt16 = 0
    private var c3: UInt16 = 0
    private var c4: UInt16 = 0
    private var c5: UInt16 = 0
    private var c6: UInt16 = 0

	private func setSampleCustomer() {
        c1 = customerList.createNewCustomer(newCustomerInfo: CustomerInformation(customerName: "João Victor Anastácio", eMailAddress: "aaa@gmail.com", isAutoSendInvoice: true, customerRate: 101)).customerID
        c2 = customerList.createNewCustomer(newCustomerInfo: CustomerInformation(customerName: "Kaiya Takahashi", eMailAddress: "bbb@gmail.com", isAutoSendInvoice: true, customerRate: 102)).customerID
        c3 = customerList.createNewCustomer(newCustomerInfo: CustomerInformation(customerName: "Keiji Suzuki", eMailAddress: "ccc@gmail.com", isAutoSendInvoice: true, customerRate: 103)).customerID
        c4 = customerList.createNewCustomer(newCustomerInfo: CustomerInformation(customerName: "Tomonao Hashiguchi", eMailAddress: "ddd@gmail.com", isAutoSendInvoice: true, customerRate: 104)).customerID
        c5 = customerList.createNewCustomer(newCustomerInfo: CustomerInformation(customerName: "Yusuke Ishihara", eMailAddress: "eee@gmail.com", isAutoSendInvoice: true, customerRate: 105)).customerID
        c6 = customerList.createNewCustomer(newCustomerInfo: CustomerInformation(customerName: "Yusuke Kohatsu", eMailAddress: "fff@gmail.com", isAutoSendInvoice: true, customerRate: 101)).customerID
    }

    private func setSampleEvent() {
        var event1 = Event(eventName: "Programing class", eventRate: 100, eventDetails: [])
		event1.eventDetails.append(EventDetail(startDateTime: Date(timeIntervalSinceNow: TimeInterval(1)), durationMinutes: 90, attendees: [c1, c2, c3, c4, c5, c6]))
		event1.eventDetails.append(EventDetail(startDateTime: Date(timeIntervalSinceNow: TimeInterval(3)), durationMinutes: 60, attendees: [c1, c3, c5]))
		event1.eventDetails.append(EventDetail(startDateTime: Date(timeIntervalSinceNow: TimeInterval(5)), durationMinutes: 60, attendees: [c2, c4, c6]))
        var event2 = Event(eventName: "João Victor Anastácio", eventRate: 100, eventDetails: [])
		event2.eventDetails.append(EventDetail(startDateTime: Date(timeIntervalSinceNow: TimeInterval(100)), durationMinutes: 90, attendees: [c1]))
        var event3 = Event(eventName: "Yoko Ono", eventRate: 50, eventDetails: [])
		event3.eventDetails.append(EventDetail(startDateTime: Date(timeIntervalSince1970: TimeInterval(1002)), durationMinutes: 90, attendees: []))

		_ = eventList.addAndUpdateEvent(event: event1)
        _ = eventList.addAndUpdateEvent(event: event2)
        _ = eventList.addAndUpdateEvent(event: event3)
    }

    private func setSampleInvoiceHistory() {
    }
}
