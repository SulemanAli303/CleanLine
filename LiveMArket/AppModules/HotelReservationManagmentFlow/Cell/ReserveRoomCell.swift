//
//  ChaletsListCell.swift
//  LiveMArket
//
//  Created by Zain on 31/01/2023.
//

import UIKit

protocol RoomListProtocol{
    func bookNowAction(room_id:String)
}

class ReserveRoomCell: UITableViewCell {
    
    @IBOutlet weak var facilityCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var roomNumber: UILabel!
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var bookNowBGView: UIButton!
    
    var delegate:RoomListProtocol?
    
    var base: UIViewController!
    var facilityArray:[Facilities] = []
    var currency : String?
    var isBookingActive:Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        facilityCollectionView.delegate = self
        facilityCollectionView.dataSource = self
        
        facilityCollectionView.register(UINib.init(nibName: "FacilityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FacilityCollectionViewCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = CGSize(width: 70, height: 60)
        self.facilityCollectionView.collectionViewLayout = layout
        self.facilityCollectionView.reloadData()
        self.facilityCollectionView.layoutIfNeeded()
    }
    
    var roomData:Rooms?{
        didSet{
            roomImageView.sd_setImage(with: URL(string: roomData?.primary_image ?? ""), placeholderImage:UIImage(named: "placeholder_profile"))
            facilityArray = roomData?.facilities ?? []
            priceLabel.text = roomData?.price ?? ""
            roomNumber.text = roomData?.name ?? ""
            self.facilityCollectionView.reloadData()
            descriptionLabel.text = roomData?.description ?? ""
            bookNowBGView.isHidden = false
            bookNowBGView.isEnabled = isBookingActive
            let currency = self.currency ?? ""
            let priceVal = " \((Double(roomData?.price ?? "")) ?? 0.0) / "
            let convertedString = roomData?.price_type?.replacingOccurrences(of: "_", with: " ").capitalized ?? ""
            
            let attributedString = NSMutableAttributedString(string: currency, attributes: [
                .font: UIFont(name: "Roboto-Regular", size: 14.0)!
            ])
            
            attributedString.append(NSMutableAttributedString(string: priceVal, attributes: [
                .font: UIFont(name: "Roboto-Bold", size: 20.0)!
            ]))
            
            attributedString.append(NSAttributedString(string: convertedString, attributes: [
                .font: UIFont(name: "Roboto-Regular", size: 14.0)!,
                .baselineOffset: 0  // Adjust the offset to align the small text
            ]))
            
            priceLabel.attributedText = attributedString
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func btnBookNow(_ sender: Any) {
        
        self.delegate?.bookNowAction(room_id: roomData?.id ?? "")
    }
}

extension ReserveRoomCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.facilityArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacilityCollectionViewCell", for: indexPath) as? FacilityCollectionViewCell else { return UICollectionViewCell() }
        cell.iconImageView.sd_setImage(with: URL(string: facilityArray[indexPath.row].icon ?? ""), placeholderImage:UIImage(named: "placeholder_profile"))
        cell.nameLabel.text = facilityArray[indexPath.row].name ?? ""
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let screenSize: CGRect = UIScreen.main.bounds
//        let screenWidth = screenSize.width
//        return CGSize(width: 100, height:40)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//
}
