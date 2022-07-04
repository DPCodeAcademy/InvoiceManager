//
//  GoogleCalendarService.swift
//
//  Created by Joao Victor Silva Anastacio on 2022-06-28.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST

class GoogleCalendarService: CalendarServiceProtocol {
    
    let noItemsReturnedValue = 0
    let requestManager = RestRequestManager.shared
    let calendarService = GTLRCalendarService()
    
    func fetchCalendarEvents(_ user: GIDGoogleUser, _ initialDate: GTLRDateTime, _ finalDate: GTLRDateTime) -> [EventModel] {
        var eventList: [EventModel] = []
        let calendarIdentifier = "primary"
        let userAuthentication = user.authentication
        calendarService.authorizer = userAuthentication.fetcherAuthorizer()

        let listCalendarEventsQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarIdentifier)
        listCalendarEventsQuery.timeMin = initialDate
        listCalendarEventsQuery.timeMax = finalDate
        
        calendarService.executeQuery(listCalendarEventsQuery) { [self](data, response, error) in
            guard error == nil, let items = (response as? GTLRCalendar_Events)?.items else {
                return
            }
            
            if items.count > self.noItemsReturnedValue {
                eventList = self.deserializeItemsToEvents(calendarEvents: items)
            } else {
                print("Authentication Required")
            }
        }
        return eventList
    }
    
    fileprivate func deserializeItemsToEvents(calendarEvents items: [GTLRCalendar_Event]) -> [EventModel] {
        var deserializedEventList: [EventModel] = []
        var attendeeList: [Attendee] = []
        
        for event in items {
            
            for attendee in event.attendees! {
                attendeeList.append(Attendee(identifier: attendee.identifier!, name: attendee.displayName!, email: attendee.email!))
            }
            
            if let startDateTime = event.start?.dateTime?.stringValue, let endDateTime = event.end?.dateTime?.stringValue {
                deserializedEventList.append(EventModel(identifier: String(event.identifier!),
                                                   name: String(event.summary!),
                                                   status: String(event.status!),
                                                   startDateTime: String(startDateTime),
                                                   endDateTime: String(endDateTime),
                                                   attendees: attendeeList))
            }
        }
        return deserializedEventList
    }
}
