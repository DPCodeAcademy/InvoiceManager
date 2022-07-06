//
//  UserSetting.swift
//  InvoiceManager
//
//  Created by 鈴木啓司 on 2022-06-29.
//

import Foundation

struct UserSetting{
    var companyName: String = "Company name"
    var paymentMethod: String = "e-Transfer"
    var companyAddress: String = "Company address"
    var logoImageURI: URL = URL(fileURLWithPath: "")
}
