
import UIKit

extension UIColor {
    
	convenience init(hex: String) {

		var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		// swiftlint:disable:next control_statement
		if (cString.hasPrefix("#")) {
			cString.remove(at: cString.startIndex)
		}
		// swiftlint:disable:next control_statement
		if ((cString.count) != 6) {
			//default is white color
			self.init(white: 1.0, alpha: 1.0)
		}

		var rgbValue: UInt64 = 0
		Scanner(string: cString).scanHexInt64(&rgbValue)

		self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
				  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
				  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
				  alpha: CGFloat(1.0))
	}

	/// toImage: Convert any color to UIImage
	///
	/// - Parameters:
	///   - width: CGRect Width
	///   - height: CGRect Height
	/// - Returns: UIImage
	func toImage(width: CGFloat = 2, height: CGFloat = 2) -> UIImage {
		let rect = CGRect(x: 0, y: 0, width: width, height: height)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

		defer { UIGraphicsEndImageContext() }

		if let context = UIGraphicsGetCurrentContext() {
			context.setFillColor(self.cgColor)
			context.fill(rect)
		}

		return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
	}

    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
