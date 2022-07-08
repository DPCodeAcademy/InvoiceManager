import Foundation

class EventViewModel {

    private var events: Set<Event> = []

    enum EventListError: Error {
        case failedUpdate
    }

    func getEventList() -> Set<Event> {
        return events
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
