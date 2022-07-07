//
//  UserSetting.swift
//  InvoiceManager
//
//  Created by 鈴木啓司 on 2022-06-29.
//

import Foundation
import UIKit

struct UserSetting{
    var companyName: String = "Company name"
    var paymentMethod: String = "e-Transfer"
    var companyAddress: String = "Company address"
    var logoImageURI: URL = URL(fileURLWithPath: "")
    var companyEmail: String = "Company Email"
    
    var logoImage: UIImage? {
        guard let imageData = try? Data(contentsOf: logoImageURI) else { return nil }
        return UIImage(data: imageData)
    }
}
