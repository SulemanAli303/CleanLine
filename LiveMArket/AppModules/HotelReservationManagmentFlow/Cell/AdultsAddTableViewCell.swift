//
//  AdultsAddTableViewCell.swift
//  LiveMArket
//
//  Created by Rupesh E on 08/08/23.
//

import UIKit

protocol AdultsProtocol{
    func roomCount(count:String)
    func adultsCount(count:String)
    func childAboveCount(count:String)
    func childsBelowCount(count:String)
}

class AdultsAddTableViewCell: UITableViewCell {

    @IBOutlet weak var adultsCountLabel: UILabel!
    @IBOutlet weak var childAboveCountLabel: UILabel!
    @IBOutlet weak var cildBelowCountLabel: UILabel!
    @IBOutlet weak var roomCountLabel: UILabel!
    
    var adultsCount:Int = 1
    var childAbove:Int = 0
    var childBelow:Int = 0
    var roomCount:Int = 1
    var personCountDelegate:AdultsProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func plusButton(_ sender: Any) {
        adultsCount += 1
        adultsCountLabel.text = "\(adultsCount)"
        self.personCountDelegate?.adultsCount(count: "\(adultsCount)")
    }
    @IBAction func minusButton(_ sender: Any) {
        if adultsCount == 0 {
            adultsCount = 0
        }else{
            adultsCount -= 1
        }
        adultsCountLabel.text = "\(adultsCount)"
        self.personCountDelegate?.adultsCount(count: "\(adultsCount)")
    }
    @IBAction func childAboveTwoPlusButtonAction(_ sender: UIButton) {
        childAbove += 1
        childAboveCountLabel.text = "\(childAbove)"
        self.personCountDelegate?.childAboveCount(count: "\(childAbove)")
    }
    @IBAction func childAboveTwoMinusButtonAction(_ sender: UIButton) {
        if childAbove == 0 {
            childAbove = 0
        }else{
            childAbove -= 1
        }
        childAboveCountLabel.text = "\(childAbove)"
        self.personCountDelegate?.childAboveCount(count: "\(childAbove)")
    }
    @IBAction func childBelowTwoPlusButtonAction(_ sender: UIButton) {
        childBelow += 1
        cildBelowCountLabel.text = "\(childBelow)"
        self.personCountDelegate?.childsBelowCount(count: "\(childBelow)")
    }
    @IBAction func childBelowTwoMinusButtonAction(_ sender: UIButton) {
        if childBelow == 0 {
            childBelow = 0
        }else{
            childBelow -= 1
        }
        cildBelowCountLabel.text = "\(childBelow)"
        self.personCountDelegate?.childsBelowCount(count: "\(childBelow)")
    }
    
    @IBAction func roomPlusButton(_ sender: Any) {
        roomCount += 1
        roomCountLabel.text = "\(roomCount)"
        self.personCountDelegate?.roomCount(count: "\(roomCount)")
    }
    @IBAction func roomMinusButton(_ sender: Any) {
        if roomCount == 0 {
            roomCount = 0
        }else{
            roomCount -= 1
        }
        roomCountLabel.text = "\(roomCount)"
        self.personCountDelegate?.roomCount(count: "\(roomCount)")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
