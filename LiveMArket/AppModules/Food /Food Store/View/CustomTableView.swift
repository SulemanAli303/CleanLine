//
//  CustomTableView.swift
//  LiveMArket
//
//  Created by Suleman Ali on 04/05/2024.
//

import Foundation
import UIKit
class CustomTableView: UITableView {

     var maxHeight = CGFloat(300)
     var minHeight = CGFloat(100)


    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }

    override public var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        if contentSize.height > maxHeight {
            return CGSize(width: contentSize.width, height: maxHeight)
        }
        else if contentSize.height < minHeight {
            return CGSize(width: contentSize.width, height: minHeight)
        }
        else {
            return contentSize
        }
    }

}
