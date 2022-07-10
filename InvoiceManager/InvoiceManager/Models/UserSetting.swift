//
//  UserSetting.swift
//  InvoiceManager
//
//  Created by 鈴木啓司 on 2022-06-29.
//

import Foundation

struct UserSetting {

    var companyName: String {
        if let name = ProcessInfo.processInfo.environment["SETTINGS_COMPANY_NAME"] {
            return String(name)
        }
        return "Company Name"
    }

	var paymentMethod: String {
        if let method = ProcessInfo.processInfo.environment["SETTINGS_COMPANY_PAYMENT_METHOD"] {
            return String(method)
        }
        return "Payment Method"
    }
	
	var eMailAddress: String {
		if let email = ProcessInfo.processInfo.environment["SETTINGS_COMPANY_EMAIL"] {
			return String(email)
		}
		return "Company eMail"
	}

    var companyAddress: String {
        if let address = ProcessInfo.processInfo.environment["SETTINGS_COMPANY_ADDRESS"] {
            return String(address)
        }
        return "Company Address"
    }

    var logoImageURI: URL {
        if let uri = ProcessInfo.processInfo.environment["SETTINGS_COMPANY_LOGO_URI"] {
            return URL(fileURLWithPath: uri)
        }
        return URL(fileURLWithPath: "")
    }
}
