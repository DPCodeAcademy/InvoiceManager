//
//  GoogleCalendarService.swift
//  InvoiceManager
//
//  Created by Joao Victor Silva Anastacio on 2022-06-28.
//

import Foundation

class GoogleCalendarService: CalendarServiceProtocol {

    let requestManager: RestRequestManager = RestRequestManager.shared()
    
    func fetchCalendarEvents(initialDate from: String, finalDate to: String) -> [Event] {
        // TODO: Add request implementation here
        // Mark: Use Google Calendar Service to manipulate all retrieved data
        requestManager.getRequestFor("http://www.google.ca")
        return []
    }
}
