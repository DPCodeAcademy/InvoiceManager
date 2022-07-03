//
//  RestRequestManager.swift
//  InvoiceManager
//
//  Created by Joao Victor Silva Anastacio on 2022-06-29.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST

class RestRequestManager: RequestManagerProtocol {
    
    static var shared: RestRequestManager = {
        let instance = RestRequestManager()
        return instance
    }()
    
    private init() {
        // Private initializer to avoid non-valid instances
    }
    
    func getRequestFor(_ baseUrl: String) {
        print("GET Request to path: " + baseUrl)
        
        let url = URL(string: baseUrl)
        
        guard let requestUrl = url else {
            fatalError("Unexpected error to generate url")
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        
        let getRequestTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Fail to perform request, error: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status Code: \(response.statusCode)")
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                // Return an valid object to be manipulated by caller function
                print("Response data string:\n \(dataString)")
            }
        }
        getRequestTask.resume()
    }
}

extension RestRequestManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
