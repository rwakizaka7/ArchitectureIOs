//
//  EKEventStoreRepository.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2020/10/11.
//  Copyright © 2020 脇坂亮汰. All rights reserved.
//

import Foundation
import EventKit

class EKEventStoreRepository {
    static let shared = EKEventStoreRepository()
    
    let eKEventStore = EKEventStore()
    
    /// notDetermined = 決まっていない
    /// authorized = 承認済み
    /// denied = 拒否
    /// restricted = 制限付き
    var eventAccessConsentStatus: EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: EKEntityType.event)
    }
    
    func requestEventAccess(completion:@escaping
                                EKEventStoreRequestAccessCompletionHandler) {
        eKEventStore.requestAccess(to: .event, completion: completion)
    }
    
    /// local = ローカルカレンダー
    /// calDAV = アカウント
    /// subscription = 参照アカウント
    func getCalendarList(types: [EKCalendarType]
                            = [.local, .calDAV, .subscription]) -> [EKCalendar] {
        return eKEventStore.calendars(for: .event).filter {
            (calendar: EKCalendar) in
            let calendar = types.contains(calendar.type)
                && (calendar.allowsContentModifications
                        || calendar.type == .subscription
                        && calendar.title == "日本の祝日")
            return calendar
        }
    }
    
    func getDefaultCalendar() -> EKCalendar {
        return eKEventStore.defaultCalendarForNewEvents!
    }
    
    func getCalendar(calendarId: String) -> EKCalendar {
        return eKEventStore.calendar(withIdentifier: calendarId)!
    }
    
    func getEvents(calendars: [EKCalendar], startDate: Date,
                          endDate: Date) -> [EKEvent] {
        let predicate = eKEventStore.predicateForEvents(
            withStart: startDate as Date, end: endDate as Date, calendars: calendars)
        return eKEventStore.events(matching: predicate)
    }
    
    func createEKEvent(calendar: EKCalendar) -> EKEvent {
        return EKEvent(eventStore: eKEventStore)
    }
    
    func seveEvent(event: EKEvent) -> Error! {
        do {
            try eKEventStore.save(event, span: .futureEvents)
            return nil
        } catch let error {
            return error
        }
    }
    
    func getEvent(_ eventId: String) -> EKEvent! {
        return eKEventStore.event(withIdentifier: eventId)
    }
    
    func deleteEvent(eventId: String) -> Error! {
        guard let event = getEvent(eventId) else {
            return NSError(domain: "イベントが既に存在しません。", code: -1, userInfo: ["eventId":eventId])
        }
        
        do {
            try eKEventStore.remove(event, span: .futureEvents)
            return nil
        } catch let error {
            return error
        }
    }
}
