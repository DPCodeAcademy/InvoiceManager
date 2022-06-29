//
//  CalendarServiceProtocol.swift
//  InvoiceManager
//
//  Created by Joao Victor Silva Anastacio on 2022-06-28.
//

import Foundation

protocol CalendarServiceProtocol {
    
    func fetchCalendarEvents(initialDate from: String, finalDate to: String) -> [Event]
}
