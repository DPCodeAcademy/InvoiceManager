//
//  CalendarServiceProtocol.swift
//  InvoiceManager
//
//  Created by Joao Victor Silva Anastacio on 2022-06-28.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST

protocol CalendarServiceProtocol {
    
    func fetchCalendarEvents(_ user: GIDGoogleUser, _ initialDate: GTLRDateTime, _ finalDate: GTLRDateTime) -> [Event]
}
