//
//  DateExtension.swift
//  InvoiceManager
//
//  Created by 鈴木啓司 on 2022-07-10.
//

import Foundation

enum Month: Int {
	typealias RawValue = Int

	case january = 1
	case february = 2
	case march = 3
	case april = 4
	case may = 5
	case june = 6
	case july = 7
	case august = 8
	case september = 9
	case october = 10
	case november = 11
	case december = 12
}

extension Date {
	func getYear() -> Int {
		return Calendar.current.component(.year, from: self)
	}

	func getMonth() -> Month {
		let month = Calendar.current.component(.month, from: self)
		return Month(rawValue: month)!
	}

	static func getEndOfMonthDate(month: Month, year: Int) -> Date {
		let cal = Calendar.current
		let comp = DateComponents(year: year, month: month.rawValue, day: 0)
		return cal.date(from: comp)!
	}
}
