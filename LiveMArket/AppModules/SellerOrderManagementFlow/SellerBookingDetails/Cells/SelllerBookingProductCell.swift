//
//  BookingProductCell.swift
//  LiveMArket
//
//  Created by Zain on 18/01/2023.
//

import UIKit

class SellerBookingProductCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var sizeColorView: UIView!
    @IBOutlet weak var sizeVarientContainer: UIView!
    @IBOutlet weak var sizeValueLabel: UILabel!
    
    @IBOutlet weak var colorVarientContainer: UIView!
    @IBOutlet weak var colorValueView: UIView!
    @IBOutlet weak var colorValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productImageView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String {
        return String(describing: self)
    }
    
    var product:Products?{
        //Need to show Size and Color Info//Adnan-27-03-24
        didSet{
            productImageView.sd_setImage(with: URL(string: product?.image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            nameLabel.text = product?.product_name ?? ""
            quantityLabel.text = ("\(product?.quantity ?? "") \("Quantity".localiz())")
            amountLabel.text = (product?.price ?? "") + "" + (product?.price ?? "")
            
            if product?.product_attribute_list != nil {
                if product?.product_attribute_list?.product_variations?.count ?? 0 == 2 {
                    //Get Size Attribute
                    let productSizeVariation = product?.product_attribute_list?.product_variations?.first
                    if let productSizeVariation {
                        sizeValueLabel.text = productSizeVariation.product_variation_attribute_value?.attribute_values ?? ""
                    }
                    
                    //Get Color Attribute
                    let productColorVariation = product?.product_attribute_list?.product_variations?.last
                    if let productColorVariation {
                        colorValueLabel.text = productColorVariation.product_variation_attribute_value?.attribute_values ?? ""
                        colorValueView.backgroundColor = UIColor.init(hex: productColorVariation.product_variation_attribute_value?.attribute_color ?? "")
                    }
                } else if product?.product_attribute_list?.product_variations?.count ?? 0 == 1 {
                    let productVariation = product?.product_attribute_list?.product_variations?.first
                    if let productVariation {
                        // Check either it's size
                        if productVariation.attribute_id == "2" {
                            sizeValueLabel.text = productVariation.product_variation_attribute_value?.attribute_values ?? ""
                        } else {
                            //hide color variation
                            sizeVarientContainer.isHidden = true
                        }
                        
                        // OR Color
                        if productVariation.attribute_id == "1" {
                            colorValueLabel.text = productVariation.product_variation_attribute_value?.attribute_values ?? ""
                            colorValueView.backgroundColor = UIColor.init(hex: productVariation.product_variation_attribute_value?.attribute_color ?? "")
                        } else {
                            //hide size variation
                            colorVarientContainer.isHidden = true
                        }
                    } else {
                        sizeColorView.isHidden = true
                    }
                } else {
                    sizeColorView.isHidden = true
                }
            } else {
                sizeColorView.isHidden = true
            }
        }
    }
    
    var currencyCode:String?{
        didSet{
            amountLabel.text = (currencyCode ?? "") + " " + (product?.price ?? "")
        }
    }
    
}
