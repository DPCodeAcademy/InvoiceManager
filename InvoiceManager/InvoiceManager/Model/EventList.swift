
import Foundation

class EventList
{
  private var events: Set<Event> = []
  
  func getEventList() -> Set<Event>{
    return events
  }
  
  func getEvent(eventName: String) -> Event?{
    for event in events{
      if event.eventName == eventName{
        return event
      }
    }
    return nil
  }
  
  func hasEvent(eventName: String) ->Bool{
    if getEvent(eventName: eventName) != nil{
      return true
    }
    return false
  }
  
  func addAndUpdateEvent(event: Event) -> Void{
    guard var existedEvent = events.update(with: event) else{
      events.insert(event)
      return
    }
    
    if !existedEvent.mergeEvent(event: event){
      return
    }
    events.remove(existedEvent)    // Later on, I'll try to change this code
    events.insert(existedEvent)
  }
  
  func updateEvent(event: Event) -> Bool{
    guard let existedEvent = events.update(with: event) else{
      return false
    }
    
    events.remove(existedEvent)    // Later on, I'll try to change this code
    events.insert(existedEvent)
    return true
  }
  
  func removeEvent(eventName: String) -> Void{
    let event: Event = Event(eventName: eventName, eventRate: 0, eventDetails: [])
    removeEvent(event: event)
  }
  
  func removeEvent(event: Event) -> Void{
    events.remove(event)
  }
}


struct Event: Hashable
{
  var eventName: String
  var eventRate: Int
  var eventDetails: [EventDetail]
  
  static func == (lhs: Event, rhs: Event) -> Bool {
    return lhs.eventName == rhs.eventName
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(eventName)
  }
  
  mutating func mergeEvent(event: Event)->Bool{
    if event.eventName != self.eventName{
      return false
    }
    
    // update rate
    self.eventRate = event.eventRate
    
    // update & merge event detail
    for inputDetail in event.eventDetails{
      if var existEventDetail = hasEventDetail(startDateTime: inputDetail.startDateTime){
        for attendee in inputDetail.attendees{
          existEventDetail.attendees.insert(attendee)
        }
        continue
      }
      eventDetails.append(inputDetail)
    }
    
    return true
  }
  
  func hasEventDetail(startDateTime: Date) -> EventDetail?{
    for eventDetail in eventDetails{
      if eventDetail.startDateTime == startDateTime{
        return eventDetail
      }
    }
    return nil
  }
}

struct EventDetail
{
  var startDateTime: Date
  var endDateTime: Date
  var attendees: Set<UInt16>
}

