//
//  HotelNewBooking.swift
//  LiveMArket
//
//  Created by Zain on 06/02/2023.
//

import UIKit

class DeliveryRequestVC: BaseViewController {
    
    var selectedIndex:Int = 0

    @IBOutlet weak var collectionView: UICollectionView!

    var optionsArray = ["Pending" ,"Accepted","Completed","Cancelled"]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop//.backWithSearchButton2
        viewControllerTitle = "Delivery Requests".localiz()
        setData()
        setCollectionData()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    func setData() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "RequestCell", bundle: nil), forCellReuseIdentifier: "RequestCell")
        tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
    func setCollectionData() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionView.collectionViewLayout = layout
        self.collectionView.reloadData()
        
    }

}
// MARK: - TableviewDelegate
extension DeliveryRequestVC : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestCell
        cell.base  = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Coordinator.goToCarbookingDetail(controller: self, step: "1")
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
extension DeliveryRequestVC: UICollectionViewDataSource , UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionsArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let topCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        switch indexPath.row {
        case selectedIndex:
        

            topCategoriesCell.baseView.backgroundColor = UIColor.init(hex: "#FFFFFF")
            topCategoriesCell.nameLabel.textColor = UIColor.init(hex: "#E77F1A")

        default:
            topCategoriesCell.baseView.backgroundColor = .clear
            topCategoriesCell.baseView.borderColor = UIColor.init(hex: "#FFFFFF")
            topCategoriesCell.baseView.borderWidth = 1
            topCategoriesCell.nameLabel.textColor = UIColor.init(hex: "#FFFFFF")
        }
        topCategoriesCell.nameLabel.text = self.optionsArray[indexPath.row]
        topCategoriesCell.layoutSubviews()
        topCategoriesCell.layoutIfNeeded()
        return topCategoriesCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        if (self.selectedIndex) <= self.optionsArray.count {
            self.selectedIndex = indexPath.row
        }
        self.collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
}
extension DeliveryRequestVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // return CGSize(width: optionsArray[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 120, height: 30)
        return CGSize(width: 140, height:50)

    }
}
