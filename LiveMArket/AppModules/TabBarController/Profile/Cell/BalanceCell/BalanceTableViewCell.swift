//
//  NotificationTableViewCell.swift
//  The Driver
//
//  Created by Murteza on 16/09/2022.
//

import UIKit

class BalanceTableViewCell: UITableViewCell {


    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblReferenceNo: UILabel!
    @IBOutlet weak var paymentType: UIButton!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var lblAmount: UILabel!
    var currencyCode:String = ""
    
    var walletAmunt : WalletEarningsList? {
        didSet {
            
        }
    }
    var currency : String? {
        didSet {
            currencyCode = currency ?? ""
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setData() {
        lblReferenceNo.text = walletAmunt?.transaction_id ?? ""
        lblAmount.text = "\(currencyCode) \(walletAmunt?.wallet_amount ?? "")"
        lblDate.text = "\(walletAmunt?.created_at ?? "")".changeDateToFormat(frmFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", toFormat: "dd MMM yyyy hh:mm a")
        paymentType.setTitle(walletAmunt?.pay_type ?? "", for: .normal)
        if ((walletAmunt?.pay_type ?? "") == "credited" || (walletAmunt?.pay_type ?? "") == "credit") {
            paymentType.backgroundColor = UIColor(hex: "00B24D")
            paymentType.setTitle("credited", for: .normal)
        }else {
            paymentType.backgroundColor = UIColor.red
        }
        descriptionLabel.text = walletAmunt?.description ?? ""
    }
}
