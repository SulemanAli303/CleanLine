

import UIKit

extension UIView {

	enum BorderlayersName: String {
		case bottom
	}

    @IBInspectable var bottomBorderWidth: CGFloat {
        get { return layer.borderWidth }
        set { addBottomBorderWithColor(color: .white, width: newValue) }
    }

	func animateConstraints(withDuration duration: TimeInterval, delay: TimeInterval = 0.0, animations: () -> Void) {
		animateConstraints(withDuration: duration, delay: delay, animations: animations, completion: nil)
	}

	func animateConstraints(withDuration duration: TimeInterval, delay: TimeInterval = 0.0, animations: () -> Void, completion: ((Bool) -> Void)?) {
		self.layoutIfNeeded()
		animations()
		UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions(rawValue: 0), animations: { () -> Void in
			self.layoutIfNeeded()
		}, completion: completion)
	}

	func animateConstraints(withDuration duration: TimeInterval, delay: TimeInterval = 0.0, options: UIView.AnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?) {
		self.layoutIfNeeded()
		animations()
		UIView.animate(withDuration: duration, delay: delay, options: options, animations: { () -> Void in
			self.layoutIfNeeded()
		}, completion: completion)
	}
	@discardableResult
	func withConstraints(_ closure: (_ view: UIView) -> [NSLayoutConstraint]) -> UIView {
		translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(closure(self))
		return self
	}

	// Layout guide

	func alignLeading(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
		return leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: constant)
	}

	func alignTrailing(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
		return trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: constant)
	}

	func alignLeft(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
		return leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: constant)
	}

	func alignRight(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
		return rightAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: constant)
	}

    func alignAny(_ fromXAxisAnchor: NSLayoutXAxisAnchor, toXAxisAnchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        return fromXAxisAnchor.constraint(equalTo: toXAxisAnchor, constant: constant)
    }

	func alignTop(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
		return topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: constant)
	}

	func alignBottom(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
		return bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: constant)
	}

    func alignAny(_ fromYAxisAnchor: NSLayoutYAxisAnchor, toYAxisAnchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		return fromYAxisAnchor.constraint(equalTo: toYAxisAnchor, constant: constant)
	}

    /** This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T */
    func allSubViewsOf<T: UIView>(type: T.Type) -> [T] {
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T {
                all.append(aView)
            }
            guard view.subviews.count > 0 else { return }
            view.subviews.forEach { getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }

	// View

	func alignLeading(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
		return leadingAnchor.constraint(equalTo: anchorView(view).leadingAnchor, constant: constant)
	}

	func alignTrailing(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
		return trailingAnchor.constraint(equalTo: anchorView(view).trailingAnchor, constant: constant)
	}

	func alignLeft(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
		return leftAnchor.constraint(equalTo: anchorView(view).leftAnchor, constant: constant)
	}

	func alignRight(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
		return rightAnchor.constraint(equalTo: anchorView(view).rightAnchor, constant: constant)
	}

	func alignTop(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
		return topAnchor.constraint(equalTo: anchorView(view).topAnchor, constant: constant)
	}

	func alignBottom(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
		return bottomAnchor.constraint(equalTo: anchorView(view).bottomAnchor, constant: constant)
	}

	func alignCenterX(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
		return centerXAnchor.constraint(equalTo: anchorView(view).centerXAnchor, constant: constant)
	}

	func alignCenterY(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
		return centerYAnchor.constraint(equalTo: anchorView(view).centerYAnchor, constant: constant)
	}

    func alignCenter(_ view: UIView? = nil) -> [NSLayoutConstraint] {
        [ alignCenterX(view),
          alignCenterY(view) ]
    }

    func alignEdges(_ view: UIView? = nil, insets: UIEdgeInsets = UIEdgeInsets.init()) -> [NSLayoutConstraint] {
        [ alignLeft(view, constant: insets.left),
          alignRight(view, constant: -insets.right),
          alignTop(view, constant: insets.top),
          alignBottom(view, constant: -insets.bottom) ]
	}

	func constraintWidth(_ width: CGFloat) -> NSLayoutConstraint {
        widthAnchor.constraint(equalToConstant: width)
	}

	func constraintHeight(_ height: CGFloat) -> NSLayoutConstraint {
        heightAnchor.constraint(equalToConstant: height)
	}

    func constraintSize(_ size: CGSize) -> [NSLayoutConstraint] {
        [ widthAnchor.constraint(equalToConstant: size.width),
          heightAnchor.constraint(equalToConstant: size.height) ]
    }

	private func anchorView(_ view: UIView?) -> UIView {
        view ?? superview!
	}

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
 
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
		clipsToBounds = true
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
		clipsToBounds = true
        self.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
		border.name = BorderlayersName.bottom.rawValue
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
		clipsToBounds = true
        self.layer.addSublayer(border)
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
		clipsToBounds = true
        self.layer.addSublayer(border)
    }

    func fixView(_ container: UIView!) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    func addDashedBorder() {
        let color = UIColor.white.cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 22).cgPath
        self.layer.addSublayer(shapeLayer)
        }
}

extension UIView {

    static let defaultCornerRadius: CGFloat = 6

    func roundView() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }

    func roundWholeView() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }

    func roundVeryLittle(radius: CGFloat = UIView.defaultCornerRadius) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }

    func minorRoundedEgdes(radius: CGFloat = UIView.defaultCornerRadius) {
       roundVeryLittle(radius: radius)
    }

    func roundOnly(radius: CGFloat? = nil) {
        if let radius = radius {
            self.layer.cornerRadius = radius
        } else {
            self.layer.cornerRadius = self.frame.size.height / 2
        }
    }

    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    func addShadow() {
        
        layer.shadowColor = UIColor.black.withAlphaComponent(0.17).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
//        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
    }

    func setGradientLayer(colorTop: CGColor, colorBottom: CGColor) -> CAGradientLayer {

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 0.1]
        return gradientLayer
    }

    func setGradientBackground(colors: [CGColor], _ cornerRadius: CGFloat = 22.0) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = cornerRadius
        if let topLayer = self.layer.sublayers?.first, topLayer is CAGradientLayer {
            topLayer.removeFromSuperlayer()
        }

        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func transitionView() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
        transition.type = .push
        transition.subtype = .fromTop
        self.layer.add(transition, forKey: kCATransition)
    }
    
    func transitionViewDown() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
        transition.type = .fade
        transition.subtype = .fromBottom
        self.layer.add(transition, forKey: kCATransition)
    }
    
    func fadeTo(_ alpha: CGFloat, duration: TimeInterval = 0.3) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration) {
                self.alpha = alpha
            }
        }
    }
    
    func fadeIn(_ duration: TimeInterval = 0.3) {
        fadeTo(1.0, duration: duration)
    }
    
    func fadeOut(_ duration: TimeInterval = 0.3) {
        fadeTo(0.0, duration: duration)
    }
}
