//
//  Event.swift
//  InvoiceManager
//  Created by Joao Victor Silva Anastacio on 2022-06-27.
//

import Foundation

struct Event {
    var identifier: UUID
    var name: String
    var status: String
    var startDateTime: Date
    var endDateTime: Date
    var attendees: [Attendee]
    var createdAt: Date
    var updatedAt: Date
}

struct Attendee {
    var identifier: UUID
    var name: String
    var email: String
}
