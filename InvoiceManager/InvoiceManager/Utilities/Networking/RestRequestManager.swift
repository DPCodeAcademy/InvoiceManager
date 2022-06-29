//
//  RestRequestManager.swift
//  InvoiceManager
//
//  Created by Joao Victor Silva Anastacio on 2022-06-29.
//

import Foundation

class RestRequestManager: RequestManagerProtocol {
    
    private static let sharedRestRequestManager: RestRequestManager = {
        let restRequestManager = RestRequestManager()
        return restRequestManager
    }()
    
    private init() {
        // Private initializer to avoid non-valid instances
    }
    
    class func shared() -> RestRequestManager {
        return sharedRestRequestManager
    }
    
    func postRequestFor(_ baseUrl: String) {
        print("POST Request Performed Successfully")
    }
    
    func getRequestFor(_ baseUrl: String) {
        print("GET Request Performed Successfully")
    }
}
