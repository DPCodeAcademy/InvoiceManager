//
//  Event.swift
//  InvoiceManager
//
//  Created by Joao Victor Silva Anastacio on 2022-07-06.
//

import Foundation

struct Event: Hashable {

    var eventName: String
    var eventRate: Int
    var eventDetails: [EventDetail]

    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.eventName == rhs.eventName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(eventName)
    }

	mutating func mergeEvent(event: Event) -> Event? {
        if event.eventName != self.eventName {
            return nil
        }

		// update rate
        self.eventRate = event.eventRate

        // update & merge event detail
        for inputDetail in event.eventDetails {
            if var existEventDetail = hasEventDetail(startDateTime: inputDetail.startDateTime) {
                for attendee in inputDetail.attendees {
                    existEventDetail.attendees.insert(attendee)
                }
                continue
            }
            eventDetails.append(inputDetail)
        }
        return self
    }

    func hasEventDetail(startDateTime: Date) -> EventDetail? {
        for eventDetail in eventDetails where eventDetail.startDateTime == startDateTime {
			return eventDetail
        }
        return nil
    }
}

struct EventDetail {
    var startDateTime: Date
    var durationMinutes: Int
    var attendees: Set<UInt16>
}

struct EventType {
	let type: String
	var event: [Event]
}
