//
//  TableBookingBillingData.swift
//  LiveMArket
//
//  Created by Shoaib Hassan's Macbook Pro M2 on 02/03/2024.
//

import UIKit

class TableBookingBillingData: NSObject {
  
    static let shared = TableBookingBillingData()
    var currency_code = ""
    var tax = ""
    var service_charge = ""
    var grand_total = ""
}
