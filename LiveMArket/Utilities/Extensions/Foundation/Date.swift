
import Foundation

let TODAY: String = "Today"
let YESTERDAY: String = "Yesterday"

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
	
    static func fromRFC3339(_ date: String) -> Date? {
		if let date = Date(iso8601String: date) {
			return date
		}
		if let date = Date(iso8601NoMilliString: date) {
			return date
		}
		return nil
	}

	static func fromRFC3339(_ date: String?) -> Date? {
		guard let date = date else {
			return nil
		}
		return fromRFC3339(date)
	}

	func toRFC3339() -> String {
		return DateFormatter.rfc3339.string(from: self)
	}

	/// Create date object from ISO8601 string (without milliseconds).
	///
	/// - Parameter iso8601NoMilliString: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ssZ).
	init?(iso8601NoMilliString: String) {
		if let date = Formatter.rfc3339short.date(from: iso8601NoMilliString) {
			self = date
		} else {
			return nil
		}
	}

	/// Create date object from ISO8601 string.
	///
	///     let date = Date(iso8601String: "2017-01-12T16:48:00.959Z") // "Jan 12, 2017, 7:48 PM"
	///
	/// - Parameter iso8601String: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSSZ).
	init?(iso8601String: String) {
		if let date = Formatter.rfc3339.date(from: iso8601String) {
			self = date
		} else {
			return nil
		}
	}

	/// Date by adding multiples of calendar component.
	///
	///     let date = Date() // "Jan 12, 2017, 7:07 PM"
	///     let date2 = date.adding(.minute, value: -10) // "Jan 12, 2017, 6:57 PM"
	///     let date3 = date.adding(.day, value: 4) // "Jan 16, 2017, 7:07 PM"
	///     let date4 = date.adding(.month, value: 2) // "Mar 12, 2017, 7:07 PM"
	///     let date5 = date.adding(.year, value: 13) // "Jan 12, 2030, 7:07 PM"
	///
	/// - Parameters:
	///   - component: component type.
	///   - value: multiples of components to add.
	/// - Returns: original date + multiples of component added.
	func adding(_ component: Calendar.Component, value: Int) -> Date {
		return Calendar.current.date(byAdding: component, value: value, to: self)!
	}

	/// Check if date is in past.
	///
	///     Date(timeInterval: -100, since: Date()).isInPast -> true
	///
	var isInPast: Bool {
		return self < Date()
	}

	func startOfDay() -> Date {
		return Calendar.current.startOfDay(for: self)
	}

	func endOfDay() -> Date {
		var components = DateComponents()
		components.day = 1
		components.second = -1
		return Calendar.current.date(byAdding: components, to: startOfDay())!
	}

	func startOfMonth() -> Date {
		let components = Calendar.current.dateComponents([.year, .month], from: startOfDay())
		return Calendar.current.date(from: components)!
	}

	func endOfMonth() -> Date {
		var components = DateComponents()
		components.month = 1
		components.second = -1
		return Calendar.current.date(byAdding: components, to: startOfMonth())!
	}

    func toString(formatter: DateFormatter = Formatter.standard) -> String {
        return formatter.string(from: self)
    }

	func daysDifferenceBetweenDates(endDate: Date) -> Int {
		guard let daysDifference = Calendar.current.dateComponents([.day], from: self, to: endDate).day else {
			return 0
		}
		return daysDifference
	}

	func dateBeforeOrAfterFromToday(days: Int) -> Date? {
		return Calendar.current.date(byAdding: .day, value: days, to: Date().adding(.day, value: 0))
	}
    
    func dateBeforeOrAfterFrom(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self.adding(.day, value: 0))
    }
}
extension Date {
    var toSting: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    var month: Int? {
        let components = self.get(.day, .month, .year)
        if let day = components.day, let month = components.month, let year = components.year {
            print("day: \(day), month: \(month), year: \(year)")
            return month
        }
        return nil
    }
    
    var year: Int? {
        let components = self.get(.day, .month, .year)
        if let day = components.day, let month = components.month, let year = components.year {
            print("day: \(day), month: \(month), year: \(year)")
            return year
        }
        return nil
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
public struct DateTemplate: Codable {

    let displayValue: String?
    let originalValue: Date

    public init(value: Date, formatter: DateFormatter = Formatter.standard) {

        displayValue = value.toString(formatter: formatter)
        originalValue = value
    }

    init?(value: String, formatter: DateFormatter = Formatter.standard) {

        guard let dateValue = formatter.date(from: value.removeCharacterAfter(characters: ".")) else {
            return nil
        }

        self.init(value: dateValue, formatter: formatter)
    }

    static func getDateTemplate(date: Date?, formatter: DateFormatter = Formatter.standard) -> DateTemplate? {

        guard let date = date else {
            return nil
        }

        return DateTemplate(value: date, formatter: formatter)
    }
}
extension Date {
    func getDateWithMonthString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    func getDateWithMonthStringFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }
    
    func getDateTime() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func getDateTimeParam() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func getWeekdayString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    func getTimeString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
}
