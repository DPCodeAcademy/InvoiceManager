import Foundation

class EventViewModel {

    private var events: Set<Event> = []

    enum EventListError: Error {
        case failedUpdate
    }

    func getEventList() -> [Event] {
        // TODO: Sort events by startDateTime.
		return Array(events)
    }
	
	func getEventList(in priod: Date) -> [Event] {
		var limitedEvents: [Event] = []
		for var event in events {
			let newEventDetails = event.eventDetails.filter { NSCalendar.current.isDate($0.startDateTime, equalTo: priod, toGranularity: .year) && NSCalendar.current.isDate($0.startDateTime, equalTo: priod, toGranularity: .month)}
			
			if newEventDetails.count != 0 {
				event.eventDetails = newEventDetails
				limitedEvents.append(event)
			}
		}
		return limitedEvents
	}
	
	// to create mutiple section table view
	func getEventOrganizedList(in priod: Date) -> [EventType] {
		var organizedList: [EventType] = [EventType(type: "Group", event: []), EventType(type: "Individual", event: [])]
		let limitedEvents = getEventList(in: priod)
		for event in limitedEvents {
			if event.eventDetails.first!.attendees.count == 1 {

				organizedList[1].event.append(event)
			} else {
				organizedList[0].event.append(event)
			}
		}
		return organizedList
	}

	func getCustomerEventList(customerID: UInt16) -> [Event] {
		var customerEvents: [Event] = []
		for event in events {
			var customerEvent = event
			customerEvent.eventDetails.removeAll()
			for eventDetail in event.eventDetails where eventDetail.attendees.contains(customerID) {
				customerEvent.eventDetails.append(eventDetail)
			}
			if !customerEvent.eventDetails.isEmpty {
				customerEvents.append(customerEvent)
			}
		}
		return customerEvents
	}

	func getCustomerEventList(customerID: UInt16, month: Month, year: Int) -> [Event] {
		var customerEvents: [Event] = []
		for customerEvent in getEventList() {
			var addEvent = customerEvent
			addEvent.eventDetails.removeAll()
			for detail in customerEvent.eventDetails where detail.startDateTime.getMonth() == month && detail.startDateTime.getYear() == year {
				addEvent.eventDetails.append(detail)
			}
			if !customerEvent.eventDetails.isEmpty {
				customerEvents.append(addEvent)
			}
		}
		return customerEvents
	}

    func getEvent(eventName: String) -> Event? {
        for event in events where event.eventName == eventName {
			return event
        }
        return nil
    }

    func removeAttendee(customerID: UInt16) {
        var newEvents: Set<Event> = []
        for var event in events {
            var isUpdated = false
            var updatedEventDetail: [EventDetail] = []

            for var eventDetail in event.eventDetails {
                if eventDetail.attendees.contains(customerID) {
                    eventDetail.attendees.remove(customerID)
                    isUpdated = true
                }
                updatedEventDetail.append(eventDetail)
            }

            if isUpdated {
                event.eventDetails = updatedEventDetail
            }

			newEvents.insert(event)
        }

        events = newEvents
    }

	func addAndUpdateEvent(event: Event) -> Event {
        guard var existedEvent = events.update(with: event) else {
            events.insert(event)
            return event
        }

		guard let updatedEvent = existedEvent.mergeEvent(event: event) else {
            assertionFailure()
            return event
        }

		events.remove(existedEvent)    // Later on, I'll try to change this code
        events.insert(updatedEvent)
        return updatedEvent
    }

	func updateEvent(event: Event) -> Bool {
        guard let existedEvent = events.update(with: event) else {
            return false
        }

		events.remove(existedEvent)    // Later on, I'll try to change this code
        events.insert(existedEvent)
        return true
    }

	func removeEvent(eventName: String) {
        let event: Event = Event(eventName: eventName, eventRate: 0, eventDetails: [])
        removeEvent(event: event)
    }

	func removeEvent(event: Event) {
        events.remove(event)
    }
}
