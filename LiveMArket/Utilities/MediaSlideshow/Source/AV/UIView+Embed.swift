//
//  AVPlayerView.swift
//  MediaSlideshow
//
//  Created by Peter Meyers on 1/7/21.
//

import AVFoundation
import Foundation
import UIKit

extension UIView {
    func embed(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.widthAnchor.constraint(equalTo: widthAnchor),
            view.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    func addDashBorder() {
        let color = Color.darkOrange.color()

            let shapeLayer:CAShapeLayer = CAShapeLayer()

            let frameSize = self.frame.size
            let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

            shapeLayer.bounds = shapeRect
            shapeLayer.name = "DashBorder"
            shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = 1.5
            shapeLayer.lineJoin = .round
            shapeLayer.lineDashPattern = [2,4]
            shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath

            self.layer.masksToBounds = false

            self.layer.addSublayer(shapeLayer)
        }
}
