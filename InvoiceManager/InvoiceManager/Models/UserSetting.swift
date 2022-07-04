//
//  UserSetting.swift
//  InvoiceManager
//
//  Created by Joao Victor Silva Anastacio on 2022-07-03.
//

import Foundation

struct UserSetting{
    var companyName: String = "Company name"
    var paymentMethod: String = "e-Transfer"
    var companyAddress: String = "Company address"
    var logoImageURI: URL = URL(fileURLWithPath: "")
}
