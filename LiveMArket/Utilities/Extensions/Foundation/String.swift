

import Foundation
import UIKit

typealias DefaultInt32 = Int32
typealias DefaultInt16 = Int16
typealias DefaultInt64 = Int64

extension String {
    
    func dateConverter(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Calendar.current.locale
        return dateFormatter.date(from: self)
    }
    
	/// SwifterSwift: Array of strings separated by given string.
	///
	///        "hello World".splited(by: " ") -> ["hello", "World"]
	///
	/// - Parameter separator: separator to split string by.
	/// - Returns: array of strings separated by given string.
	func splitted(by separator: Character) -> [String] {
		return split { $0 == separator }.map(String.init)
	}

    func get_numbers() -> Array<DefaultInt32> {
        return self
            .components(separatedBy: ",")
            .compactMap({  DefaultInt32($0.trimmingCharacters(in: .whitespaces)) })
    }

	/// SwifterSwift: Array of characters of a string.
	///
    var charactersArray: [Character] {
        return Array(self)
    }

    func isEmptyOrWhitespace() -> Bool {

        if self.isEmpty {
            return true
        }
        return (self.trimmingCharacters(in: NSCharacterSet.whitespaces) == "")
    }

    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func base64Decoder() -> String? {
        var st = self
        if self.count % 4 <= 2 {
            st += String(repeating: "=", count: (self.count % 4))
        }
        guard let data = Data(base64Encoded: st) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    public var length: Int {
        count
    }

    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,100}").evaluate(with: self)
    }
    
    var isValidPassword: Bool {
          let regularExpression = "^(?=.*[a-z]{8,15}$"
          let passwordValidation = NSPredicate(format: "SELF MATCHES %@", regularExpression)
          return passwordValidation.evaluate(with: self)
      }
    
    var isValidUserName : Bool {
        let userNameRegEx = "^[a-z ]{3,25}$"
        let userNameChecker = NSPredicate(format:"SELF MATCHES[c] %@", userNameRegEx)
        return userNameChecker.evaluate(with: self)
    }
    
    var isValidUAENumber: Bool {
        NSPredicate(format: "SELF MATCHES %@", "^((?:3|4|5|6|7|9|50|51|52|55|56)[0-9]{8,})$").evaluate(with: self)
    }
    
    var isValidKSANumber: Bool {
        NSPredicate(format: "SELF MATCHES %@", "^((?:5|0|3|6|4|9|1|8|7)[0-9]{8,})$").evaluate(with: self)
    }

	var isNumber: Bool {
        !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
	}
    
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue.rounded(toPlaces: 2)
    }
    
    func toInteger() -> Int? {
        return NumberFormatter().number(from: self)?.intValue
    }
    
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
    
    func trimmingLeadingAndTrailingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return trimmingCharacters(in: characterSet)
    }
    
    mutating func addString(str: String) {
        self = self + str
    }
    
	subscript(r: CountableClosedRange<Int>) -> String? {
		guard r.lowerBound >= 0, let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound, limitedBy: self.endIndex),
			let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound, limitedBy: self.endIndex) else { return nil }
		return String(self[startIndex ... endIndex])
	}

	init?(data: Data?, encoding: String.Encoding) {
		guard let data = data else {
			return nil
		}
		self.init(data: data, encoding: encoding)
	}

	func removeCharacterAfter(characters: String) -> String {
		if let index = self.range(of: characters)?.lowerBound {
			return String(self.prefix(upTo: index))
		}
		return self
	}

	func render (dict: [String: String]) -> String {
		var actualString = self
		for (key, value) in dict {
			actualString = actualString.replacingOccurrences(of: "{\(key)}", with: value)
		}
		return actualString
	}

	func getHTMLBody() -> String {
		//let attr = try? NSAttributedString(htmlString: "\(QCSSharedUtils.extractStringValue(htmlContent))", font: QCSTheme.shared.font(forKey: .defaultRegularFont, size: QCSTheme.shared.defaultFontSize + 15.0))

		return """
		<html>
		<head>
		<meta name=\'viewport\' content=\'width=device-width, initial-scale=1\'>
		</head>
		<body>
		\(self)
		</body>
		</html>
		"""

	}

    static func loremIpsum(ofLength length: Int = 445) -> String {
        guard length > 0 else { return "" }

        // https://www.lipsum.com/
        let loremIpsum = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        if loremIpsum.count > length {
            return String(loremIpsum[loremIpsum.startIndex..<loremIpsum.index(loremIpsum.startIndex, offsetBy: length)])
        }
        return loremIpsum
    }

    var fontIconString: String {
        if let charCode = UInt32(self, radix: 16), let unicode = UnicodeScalar(charCode) {
            return String(unicode)
        }
        return ""
    }

    
    func date(formatter: DateFormatter = Formatter.standard) -> Date? {
        if let date = formatter.date(from: self) {
            return date
        }
        return nil
    }

    func getDateString(formatter: DateFormatter = Formatter.standard) -> String? {

        guard let dateValue = formatter.date(from: self.removeCharacterAfter(characters: ".")) else {
            return nil
        }

        return convertDateToString(value: dateValue)
    }

     func convertDateToString(value: Date) -> String {

        let formatters = Formatter.standardDate
        return value.toString(formatter: formatters)
    }
    
}

extension UIButton {
    @IBInspectable var localizedTitle: String {
        get { return "" }
        set {
            self.setTitle(newValue.localiz(), for: .normal)
        }
    }
}

extension UILabel {
    
    @IBInspectable var localizableText: String? {
        get { return text }
        set(value) { text = value!.localiz() }
    }
}

//protocol Localizable {
//    var localized: String { get }
//}
//
//extension String: Localizable {
//    var localized: String {
//        guard let bundlePath = Bundle.main.path(forResource: AppLanguageManager.shared.currentLanguage.languageEquilant.rawValue, ofType: "lproj"),
//              let bundle = Bundle(path: bundlePath) else {
//            return NSLocalizedString(self, comment: "")
//        }
//        return NSLocalizedString(self, tableName: nil, bundle: bundle, comment: "")
//    }
//}


extension String {
     func timeFrom() -> (day: Self, time: Self)? {
        
        if let createdDate = self.date(formatter: .backendWithTime) {
            let createdDateStr = createdDate.toString(formatter: .dayMonthYear)
            let todayDateStr = Date().toString(formatter: .dayMonthYear)
            let yesterdayDateStr = Date().addingTimeInterval(-86400).toString(formatter: .dayMonthYear)
            
            var day = ""
            let time = createdDate.toString(formatter: .standardTimeOnly)
            
            if(createdDateStr == todayDateStr) {
                day = TODAY
            } else if(createdDateStr == yesterdayDateStr) {
                day = YESTERDAY
            } else {
                day = createdDate.toString(formatter: .dayInLetters)
            }
            
            return (day, time)
        }
        
        return nil
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
