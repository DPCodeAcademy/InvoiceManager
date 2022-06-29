//
//  RequestManagerProtocol.swift
//  InvoiceManager
//
//  Created by Joao Victor Silva Anastacio on 2022-06-29.
//

import Foundation

protocol RequestManagerProtocol {
    
    func postRequestFor(_ baseUrl: String)
    func getRequestFor(_ baseUrl: String)
}
