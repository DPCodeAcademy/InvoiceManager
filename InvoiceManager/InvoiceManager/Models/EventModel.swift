//
//  Event.swift
//  InvoiceManager
//  Created by Joao Victor Silva Anastacio on 2022-06-27.
//

import Foundation

struct EventModel {
    var identifier: String
    var name: String
    var status: String
    var startDateTime: String
    var endDateTime: String
    var attendees: [Attendee]
}

struct Attendee {
    var identifier: String
    var name: String
    var email: String
}

