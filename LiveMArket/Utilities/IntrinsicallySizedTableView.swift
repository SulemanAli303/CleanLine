//
//  IntrinsicallySizedTableView.swift
//  Opium
//
//  Created by Zain on 18/12/2021.
//

import Foundation
import UIKit
class IntrinsicallySizedTableView: UITableView {

  override func layoutSubviews() {
    super.layoutSubviews()
    self.invalidateIntrinsicContentSize()
  }
  
  override var intrinsicContentSize: CGSize {
    guard let dataSource = self.dataSource else {
      return super.intrinsicContentSize
    }
    var height: CGFloat = (tableHeaderView?.intrinsicContentSize.height ?? 0)
      + contentInset.top + contentInset.bottom
    if let footer = tableFooterView {
      height += footer.intrinsicContentSize.height
    }
    let nsections = dataSource.numberOfSections?(in: self) ?? self.numberOfSections
    for section in 0..<nsections {
      let sectionheader = rectForHeader(inSection: section)
      height += sectionheader.height
      let sectionfooter = rectForFooter(inSection: section)
      height += sectionfooter.height
      let nRowsSection = self.numberOfRows(inSection: section)
      for row in 0..<nRowsSection {
        height += self.rectForRow(at: IndexPath(row: row, section: section)).size.height
      }
    }
    return CGSize(width: UIView.noIntrinsicMetric, height: height)
  }
}
