

import Foundation

 public extension Formatter {
	static let rfc3339: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
		return formatter
	}()

	// No fractional seconds
	static let rfc3339short: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
		return formatter
	}()
    
    
    static let backendWithTime: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"//"yyyy-MM-dd HH:mm:ss ZZZ"
//        formatter.locale = Locale.current
        return formatter
    }()
    
    static let backendWithTimeUTC: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"//"yyyy-MM-dd HH:mm:ss ZZZ"
//        formatter.locale = Locale.current
        return formatter
    }()
    
    static let singalRWithTimeUTC: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//"yyyy-MM-dd HH:mm:ss ZZZ"
//        formatter.locale = Locale.current
        return formatter
    }()
    
    static let singalR2WithTimeUTC: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = "dd/MM/yy HH:mm:ss"//"yyyy-MM-dd HH:mm:ss ZZZ"
//        formatter.locale = Locale.current
        return formatter
    }()
    
    static let backendWithMiliSecondTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//"yyyy-MM-dd HH:mm:ss ZZZ"
        formatter.locale = Locale.current
        return formatter
    }()

	static let date: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.calendar = Calendar.current
		formatter.locale = Locale.current
		formatter.dateFormat = "E d MMM yyyy"
		return formatter
	}()

	static let time: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.calendar = Calendar.current
		formatter.locale = Locale.current
		formatter.dateStyle = .none
		formatter.timeStyle = .short
		return formatter
	}()

	  static let standard: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.calendar = Calendar.current
		formatter.locale = Locale.current
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//"yyyy-MM-dd HH:mm:ss"
		return formatter
	}()

	static let standardDateOnly: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = Calendar.current
		formatter.locale = Locale.current
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter
	}()
    
    static let standardDateWithTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale.current
        formatter.dateFormat = "dd MMM yyyy hh:mm a"
        return formatter
    }()

    static let standardDate: DateFormatter = {

        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale.current
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()


     static let dayMonthYear: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.timeStyle = .medium
        formatter.calendar = Calendar.current
        formatter.locale = Locale.current
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    
     static let standardTime: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.timeStyle = .medium
        formatter.calendar = Calendar.current
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    
    static let standardTimeOnly: DateFormatter = {
       let formatter = DateFormatter()
//        formatter.timeStyle = .medium
       formatter.calendar = Calendar.current
       formatter.locale = Locale.current
       formatter.dateFormat = "hh:mm aa"
       return formatter
   }()
    
    
    static let dayOnly: DateFormatter = {
       let formatter = DateFormatter()
//        formatter.timeStyle = .medium
       formatter.calendar = Calendar.current
       formatter.locale = Locale.current
       formatter.dateFormat = "dd"
       return formatter
   }()
    
    static let monthOnly: DateFormatter = {
       let formatter = DateFormatter()
//        formatter.timeStyle = .medium
       formatter.calendar = Calendar.current
       formatter.locale = Locale.current
       formatter.dateFormat = "MMM"
       return formatter
   }()
    
    static let yearOnly: DateFormatter = {
       let formatter = DateFormatter()
//        formatter.timeStyle = .medium
       formatter.calendar = Calendar.current
       formatter.locale = Locale.current
       formatter.dateFormat = "yyyy"
       return formatter
   }()
    
    
    static let dayInLetters: DateFormatter = {
       let formatter = DateFormatter()
//        formatter.timeStyle = .medium
       formatter.calendar = Calendar.current
       formatter.locale = Locale.current
       formatter.dateFormat = "dd"
       return formatter
   }()
}
