
import CoreGraphics

extension CGRect {

    static func + (lhs: CGRect, rhs: CGFloat) -> CGRect {

        var leftRect = lhs
        leftRect.size.height += rhs
        return leftRect

    }
}
